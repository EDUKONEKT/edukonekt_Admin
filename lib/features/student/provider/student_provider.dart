import 'dart:async';
import 'package:edukonekt_admin/core/models/parent_model.dart';
import 'package:flutter/foundation.dart';
import '../../../core/models/student_model.dart';
import '../../parent/service/parent_service.dart';
import '../../user/service/user_service.dart';
import 'package:logger/logger.dart';

import '../services/student_service.dart';

final Logger _log = Logger();

class StudentProvider extends ChangeNotifier {
  StudentProvider();

  late StudentService _service;
  late StreamSubscription<List<Student>> _sub;

  List<Student> _students = [];
  List<Student> get students => List.unmodifiable(_students);

  bool _ready = false;
  bool get isReady => _ready;

  Object? _error;
  Object? get error => _error;

  /// Initialise le service et lance l’écoute des étudiants.
  /// Obligatoire d’appeler cette méthode après création du provider.
  Future<void> init({
    required String schoolId,
    required ParentService parentService,
    required UserService userService,
  }) async {
    _service = StudentService(
      schoolId: schoolId,
      parentService: parentService,
      userService: userService,
    );

    try {
      // Chargement initial rapide depuis le cache
      _students = await _service.getStudentsOnce();
      _ready = true;
      _error = null;
      notifyListeners();

      // Abonnement au stream avec gestion des erreurs
      _sub = _service.watchStudents().listen((data) {
        _students = data;
        _error = null;
        notifyListeners();
      }, onError: (e, stack) {
        _error = e;
        _log.e('StudentProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      });
    } catch (e, stack) {
      _error = e;
      _ready = false;
      _log.e('StudentProvider init error', error: e, stackTrace: stack);
      notifyListeners();
    }
  }

  // CRUD via service

  Future<void> addStudent(Student s) async {
    try {
      await _service.addStudent(s);
    } catch (e, stack) {
      _log.e('addStudent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> updateStudent(Student s) async {
    try {
      await _service.updateStudent(s);
    } catch (e, stack) {
      _log.e('updateStudent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> removeStudent(String id) async {
    try {
      await _service.deleteStudent(id);
    } catch (e, stack) {
      _log.e('removeStudent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> createStudentWithParent({
    required String parentEmail,
     required String plainPassword,
    required Parent parentT,
    required Student studentTemplate,
  }) async {
    try {
      await _service.createStudentWithParent(
        parentEmail: parentEmail,
        plainPassword:plainPassword,
        parentT: parentT,
        studentTemplate: studentTemplate,
      );
    } catch (e, stack) {
      _log.e('createStudentWithParent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
