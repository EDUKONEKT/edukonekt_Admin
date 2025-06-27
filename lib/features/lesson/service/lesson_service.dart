import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/lesson_model.dart';

class LessonService {
  final String schoolId;
  late final CollectionReference _collection;

  LessonService({required this.schoolId}) {
    _collection = FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('lessons');
  }

  CollectionReference get ref => _collection;

  Future<void> addLesson(Lesson lesson) async {
    await _collection.doc(lesson.id).set(
      lesson.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateLesson(Lesson lesson) async {
    await _collection.doc(lesson.id).update(lesson.toFirestore());
  }

  Future<void> deleteLesson(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<Lesson>> getAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Lesson?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return Lesson.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (_) {
      return null;
    }
  }

  Stream<List<Lesson>> watch() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  Future<void> sync(List<Lesson> unsynced) async {
    for (final lesson in unsynced) {
      await _collection.doc(lesson.id).set(
        lesson.copyWith(isSynced: true).toFirestore(),
        SetOptions(merge: true),
      );
    }
  }

  Future<List<Lesson>> getByClass(String classId) async {
    try {
      final snapshot = await _collection.where('classId', isEqualTo: classId).get();
      return snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Stream<List<Lesson>> watchByClass(String classId) {
    return _collection
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Lesson.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}
