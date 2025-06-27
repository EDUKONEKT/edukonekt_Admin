import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/course_session_model.dart';

class CourseSessionService {
  final String schoolId;
  late final CollectionReference _collection;

  CourseSessionService({required this.schoolId}) {
    _collection = FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('course_sessions');
  }

  CollectionReference get ref => _collection;

  Future<void> addCourseSession(CourseSession session) async {
    await _collection.doc(session.id).set(
      session.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateCourseSession(CourseSession session) async {
    await _collection.doc(session.id).update(session.toFirestore());
  }

  Future<void> deleteCourseSession(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<CourseSession>> getAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<CourseSession?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (_) {
      return null;
    }
  }

  Stream<List<CourseSession>> watch() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  Future<void> sync(List<CourseSession> unsynced) async {
    for (final session in unsynced) {
      await _collection.doc(session.id).set(
        session.copyWith(isSynced: true).toFirestore(),
        SetOptions(merge: true),
      );
    }
  }

  Future<List<CourseSession>> getByClass(String classId) async {
    try {
      final snapshot = await _collection.where('classId', isEqualTo: classId).get();
      return snapshot.docs
          .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<CourseSession>> getByTeacher(String teacherId) async {
    try {
      final snapshot = await _collection.where('teacherId', isEqualTo: teacherId).get();
      return snapshot.docs
          .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<CourseSession>> getByDay(int dayOfWeek) async {
    try {
      final snapshot = await _collection.where('dayOfWeek', isEqualTo: dayOfWeek).get();
      return snapshot.docs
          .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<CourseSession>> getByAcademicYear(String academicYear) async {
    try {
      final snapshot = await _collection.where('academicYear', isEqualTo: academicYear).get();
      return snapshot.docs
          .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Stream<List<CourseSession>> watchByClass(String classId) {
    return _collection
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}
