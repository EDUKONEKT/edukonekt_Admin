import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/teacher_assignment_model.dart';

class TeacherAssignmentService {
  final String schoolId;
  late final CollectionReference _collection;

  TeacherAssignmentService({required this.schoolId}) {
    _collection = FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('teacher_assignments');
  }

  CollectionReference get ref => _collection;

  Future<void> addAssignment(TeacherAssignment assignment) async {
    await _collection.doc(assignment.id).set(
      assignment.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateAssignment(TeacherAssignment assignment) async {
    await _collection.doc(assignment.id).update(assignment.toFirestore());
  }

  Future<void> deleteAssignment(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<TeacherAssignment>> getAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<TeacherAssignment?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (_) {
      return null;
    }
  }

  Stream<List<TeacherAssignment>> watch() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  Future<void> sync(List<TeacherAssignment> unsynced) async {
    for (final assignment in unsynced) {
      await _collection.doc(assignment.id).set(
        assignment.copyWith(isSynced: true).toFirestore(),
        SetOptions(merge: true),
      );
    }
  }

  Future<List<TeacherAssignment>> getByTeacher(String teacherId) async {
    try {
      final snapshot = await _collection.where('teacherId', isEqualTo: teacherId).get();
      return snapshot.docs
          .map((doc) => TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeacherAssignment>> getByClass(String classId) async {
    try {
      final snapshot = await _collection.where('classId', isEqualTo: classId).get();
      return snapshot.docs
          .map((doc) => TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeacherAssignment>> getByAcademicYear(String year) async {
    try {
      final snapshot = await _collection.where('academicYear', isEqualTo: year).get();
      return snapshot.docs
          .map((doc) => TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeacherAssignment>> getByTerm(String term) async {
    try {
      final snapshot = await _collection.where('term', isEqualTo: term).get();
      return snapshot.docs
          .map((doc) => TeacherAssignment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
