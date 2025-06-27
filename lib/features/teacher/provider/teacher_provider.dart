import 'dart:async';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../core/models/teacher_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/email_utils.dart';

import '../../../core/utils/password_utils.dart';
import '../../../core/utils/temp_password_storage_service.dart';
import '../../user/provider/user_provider.dart';
import '../../user/service/user_service.dart';
import '../service/teacher_service.dart';

final Logger _log = Logger();

class TeacherProvider with ChangeNotifier {
  TeacherProvider();

  late final TeacherService _service;
  late String _schoolId;
  late StreamSubscription<List<Teacher>> _sub;

  final List<Teacher> _teachers = [];
  List<Teacher> get teachers => List.unmodifiable(_teachers);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isReady = false;
  bool get isReady => _isReady;

  Object? _error;
  Object? get error => _error;

  Future<void> init(String schoolId) async {
    _schoolId = schoolId;
    _service = TeacherService();
    _isLoading = true;
    notifyListeners();

    try {
      _teachers.clear();
      _teachers.addAll(await _service.getTeachersOnce(schoolId));
      _isReady = true;
      notifyListeners();

      _sub = _service.watchTeachers(schoolId).listen((newList) {
        _teachers
          ..clear()
          ..addAll(newList);
        notifyListeners();
      }, onError: (e, s) {
        _error = e;
        _log.e('TeacherProvider stream error', error: e, stackTrace: s);
        notifyListeners();
      });
    } catch (e, s) {
      _error = e;
      _log.e('TeacherProvider init error', error: e, stackTrace: s);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTeacherOffline({
    required String fullName,
    required String phone,
    required String gender,
    required List<String> subjects,
    required UserService userService,
  }) async {
    if (_teachers.any((t) =>
        t.fullName.trim().toLowerCase() == fullName.trim().toLowerCase() ||
        t.phone.trim() == phone.trim())) {
      throw Exception('Un enseignant avec ce nom ou ce numéro existe déjà.');
    }

    final email = generateEmailFromName(fullName);
    final password = generateRandomPassword();

    final userDoc = _service.userCol.doc();
    final user = User(
      id: userDoc.id,
      authUid: '',
      role: 'teacher',
      email: email,
      username: email,
      passwordTemporaire: true,
      requiresAccount: true,
      temporaryPassword: password,
      isSynced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await TempPasswordStorageService.savePassword(user.id, password);
    await _service.addUserToFirestore(user); // Ne pas await pour offline
    print('okayuser');

    final teacherDoc = _service.teacherCol(_schoolId).doc();
    final teacher = Teacher(
      id: teacherDoc.id,
      userId: user.id,
      fullName: fullName,
      phone: phone,
      email: email,
      gender: gender,
      profilePictureUrl: '',
      subjects: subjects,
      isSynced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      requiresAccount: true,
    );

    _service.addTeacher(_schoolId, teacher); // Ne pas await pour offline
    
     print('okayteach');
    notifyListeners();

    _log.i('📝 Enseignant créé hors ligne : ${teacher.fullName}');
  }

 Future<void> syncPendingAccounts(UserProvider userProvider) async {
  _log.i('🌀 syncPendingAccounts() via SharedPreferences + cache local');

  try {
    final ids = await TempPasswordStorageService.listIds();

    for (final userId in ids) {
      final user = userProvider.getUserLocallyById(userId);

      if (user == null || !user.requiresAccount || user.authUid.isNotEmpty) {
        _log.i('⏭ Utilisateur $userId déjà synchronisé ou introuvable');
        continue;
      }

      final tempPwd = await TempPasswordStorageService.getPassword(userId);
      if (tempPwd == null || tempPwd.isEmpty) {
        _log.w('⛔ Pas de mot de passe pour $userId');
        continue;
      }

      try {
        _log.i('🔐 Création Auth pour ${user.email}');
        final cred = await userProvider.service.auth.createUserWithEmailAndPassword(
          email: user.email,
          password: tempPwd,
        );

        final updatedUser = user.copyWith(
          authUid: cred.user!.uid,
          requiresAccount: false,
          temporaryPassword: null,
          updatedAt: DateTime.now(),
          isSynced: false,
        );

        await userProvider.service.updateUser(updatedUser);
        await TempPasswordStorageService.removePassword(userId);

        final teacher = _teachers.firstWhereOrNull((t) => t.userId == userId);
        if (teacher != null) {
          await _service.updateTeacherFields(_schoolId, teacher.id, {
            'requiresAccount': false,
            'updatedAt': DateTime.now(),
            'isSynced': false,
          });
        }

        _log.i('✅ Synchro réussie pour ${user.email}');
      } on fb.FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _log.w('⚠️ Email déjà utilisé : ${user.email}');
          await userProvider.service.updateUser(user.copyWith(
            requiresAccount: false,
            updatedAt: DateTime.now(),
            isSynced: false,
          ));
          await TempPasswordStorageService.removePassword(userId);
        } else {
          _log.e('💥 Erreur FirebaseAuth (${e.code})', error: e);
        }
      } catch (e, s) {
        _log.e('❌ Erreur inconnue pour ${user.email}', error: e, stackTrace: s);
      }
    }
  } catch (e, s) {
    _log.e('❌ syncPendingAccounts global error', error: e, stackTrace: s);
  }
}



  Teacher? getById(String id) {
  try {
    return _teachers.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
}


  void startNetworkListener(UserProvider userProv) {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await syncPendingAccounts(userProv);
      }
    });
  }

  Teacher? getByPhone(String phone) => _service.getByPhone(_teachers, phone);
  Teacher? getByEmail(String email) => _service.getByEmail(_teachers, email);
  List<Teacher> filterBySubject(String subjectId) => _service.filterBySubject(_teachers, subjectId);
  List<Teacher> filterBySubjects(List<String> ids) => _service.filterBySubjects(_teachers, ids);
  List<Teacher> get unsyncedTeachers => _teachers.where((t) => !t.isSynced).toList();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  TeacherService get service => _service;
}
