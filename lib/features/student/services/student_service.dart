import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:logger/logger.dart';

import '../../../core/models/parent_model.dart';
import '../../../core/models/student_model.dart';
import '../../parent/service/parent_service.dart';
import '../../user/service/user_service.dart';
import '../../../core/models/user_model.dart' as app_user;


final Logger _log = Logger();


class StudentService {
  StudentService({
    required this.schoolId,
    required this.parentService,
    required this.userService,
  })  : _db = FirebaseFirestore.instance,
        _auth = auth.FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final auth.FirebaseAuth _auth;
  final String schoolId;
  final ParentService parentService;
  final UserService userService;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('schools').doc(schoolId).collection('students');

  // -------------------------------------------------------------------------
  // CRUD DIRECT (si on a déjà un parentId existant)
  // -------------------------------------------------------------------------
  Future<void> addStudent(Student s) async {
    try {
      await _col.doc(s.id).set({
        ...s.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isSynced': false,
      });
    } on FirebaseException catch (e, s) {
      _log.e('addStudent FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('addStudent Exception', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateStudent(Student s) async {
    try {
      await _col.doc(s.id).update({
        ...s.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isSynced': false,
      });
    } on FirebaseException catch (e, s) {
      _log.e('updateStudent FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('updateStudent Exception', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _col.doc(id).delete();
    } on FirebaseException catch (e, s) {
      _log.e('deleteStudent FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('deleteStudent Exception', error: e, stackTrace: s);
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // STREAM (offline‑first)
  // -------------------------------------------------------------------------
  Stream<List<Student>> watchStudents() {
    return _col
        .orderBy('fullName')
        .snapshots(includeMetadataChanges: true)
        .map((q) => q.docs
            .map((d) {
              final st = Student.fromFirestore(d.data(), d.id);
              return st.copyWith(isSynced: !d.metadata.hasPendingWrites);
            })
            .toList());
  }

  Future<List<Student>> getStudentsOnce() async {
    final snap = await _col.get(const GetOptions(source: Source.cache));
    return snap.docs
        .map((d) => Student.fromFirestore(d.data(), d.id))
        .toList();
  }

  // -------------------------------------------------------------------------
  // createStudentWithParent – chaine: Auth ➜ User ➜ Parent ➜ Student
  // -------------------------------------------------------------------------
  Future<void> createStudentWithParent({
    required String parentEmail,
     required String plainPassword,
    required Parent parentT,
    required Student studentTemplate,
  }) async {
    // 👇 Nécessite la connexion internet
    if (_auth.currentUser == null) {
      // On suppose que l’admin est déjà authentifié (en ligne). Sinon on lèvera quand même.
    }

    try {
      // 1️⃣ Génère password aléatoire
    

      // 2️⃣ Crée le parent dans Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: parentEmail,
        password: plainPassword,
      );
      final authUid = cred.user!.uid;

      // 3️⃣ Crée le doc User (Firestore)
      final userDoc = _db.collection('users').doc();
      final appUser = app_user.User(
        id: userDoc.id,
        authUid: authUid,
        role: 'parent',
        email: parentEmail,
        username: parentEmail, // username = email pour l’instant
        passwordTemporaire: true,
        isSynced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(), 
        requiresAccount:false,
         temporaryPassword: '',
      );
      await userService.addUserToFirestore(appUser);


      // 4️⃣ Crée le Parent (Firestore) lié au userId
      final parentDoc = _db
          .collection('schools')
          .doc(schoolId)
          .collection('parents')
          .doc();
      final parent = Parent(
        id: parentDoc.id,
        userId: appUser.id,
        fatherfullName: parentT.fatherfullName,
        motherfullName: parentT.motherfullName,
        tutorfullName:  parentT.tutorfullName,
        fatherPhone: parentT.fatherPhone,
        motherPhone: parentT.motherPhone,
        tutorPhone: parentT.tutorPhone,
        fatherAddress: parentT.fatherAddress, 
        motherAddress: parentT.motherAddress,
        tutorAddress: parentT.tutorAddress,
        isSynced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),    
      );
      await parentService.addParent(parent);

      // 5️⃣ Crée le Student lié au parentId
      final student = studentTemplate.copyWith(
        parentId: parent.id,
        isSynced: false,
      );
      await addStudent(student);

      _log.i('createStudentWithParent SUCCESS : student ${student.id} parent ${parent.id}');
    } catch (e, s) {
      _log.e('createStudentWithParent ERROR', error: e, stackTrace: s);
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // Helper – génération mot de passe temporaire (8 chars aléatoires)
  // -------------------------------------------------------------------------
 
}
