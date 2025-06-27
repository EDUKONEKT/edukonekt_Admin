import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../core/models/teacher_model.dart';
import '../../../core/models/user_model.dart' as app_user;
import 'package:collection/collection.dart';

class TeacherService {
 // final Logger _log = Logger();
  final _db = FirebaseFirestore.instance;
  final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> teacherCol(String schoolId) =>
      _db.collection('schools').doc(schoolId).collection('teachers');

  CollectionReference<Map<String, dynamic>> get userCol =>
      _db.collection('users');

  /// 🔁 Stream temps réel
  Stream<List<Teacher>> watchTeachers(String schoolId) {
    return teacherCol(schoolId).snapshots(includeMetadataChanges: true).map(
      (snap) => snap.docs.map((doc) {
        final teacher = Teacher.fromFirestore(doc.data(), doc.id);
        return teacher.copyWith(isSynced: !doc.metadata.hasPendingWrites);
      }).toList(),
    );
  }

  /// 📥 Lecture cache
  Future<List<Teacher>> getTeachersOnce(String schoolId) async {
    final snap = await teacherCol(schoolId).get(const GetOptions(source: Source.cache));
    return snap.docs.map((doc) => Teacher.fromFirestore(doc.data(), doc.id)).toList();
  }

  /// ➕ Add
  Future<void> addTeacher(String schoolId, Teacher t) async {
  final now = DateTime.now();

  final data = {
    ...t.toFirestore(),
    'createdAt':  now,
    'updatedAt': now,
    'isSynced': false,
  };

  await teacherCol(schoolId).doc(t.id).set(data);
}


  /// ✏️ Update
  Future<void> updateTeacher(String schoolId, Teacher t) async {
     teacherCol(schoolId).doc(t.id).update({
      ...t.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isSynced': false,
    });
  }

  /// ❌ Delete
  Future<void> deleteTeacher(String schoolId, String id) async {
    await teacherCol(schoolId).doc(id).delete();
  }

  /// ➕ Add user
  Future<void> addUserToFirestore(app_user.User user) async {
  final now = DateTime.now();

  final data = {
    ...user.toFirestore(),
    'createdAt': now,
    'updatedAt':  now,
    'isSynced': false,
  };

  userCol.doc(user.id).set(data);
}


  /// 🔍 Filtres
 Teacher? getByPhone(List<Teacher> list, String phone) =>
    list.firstWhereOrNull((t) => t.phone.trim() == phone.trim());

  Teacher? getByEmail(List<Teacher> list, String email) =>
      list.firstWhereOrNull((t) => t.email.trim().toLowerCase() == email.trim().toLowerCase());

  List<Teacher> filterBySubject(List<Teacher> list, String subjectId) =>
      list.where((t) => t.subjects.contains(subjectId)).toList();

  List<Teacher> filterBySubjects(List<Teacher> list, List<String> subjectIds) =>
      list.where((t) => t.subjects.any(subjectIds.contains)).toList();

      Future<void> updateTeacherFields(String schoolId, String id, Map<String, dynamic> fields) async {
  await teacherCol(schoolId).doc(id).update({
    ...fields,
    'updatedAt': FieldValue.serverTimestamp(),
    'isSynced': false,
  });
}
}