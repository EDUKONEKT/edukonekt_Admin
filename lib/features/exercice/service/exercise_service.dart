import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/exercise_model.dart';

class ExerciseService {
  final String schoolId;
  late final CollectionReference _collection;

  ExerciseService({required this.schoolId}) {
    _collection = FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('exercises');
  }

  CollectionReference get ref => _collection;

  Future<void> addExercise(Exercise exercise) async {
    await _collection.doc(exercise.id).set(
      exercise.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateExercise(Exercise exercise) async {
    await _collection.doc(exercise.id).update(exercise.toFirestore());
  }

  Future<void> deleteExercise(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<Exercise>> getAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Exercise?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (_) {
      return null;
    }
  }

  Stream<List<Exercise>> watch() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  Future<void> sync(List<Exercise> unsynced) async {
    for (final exercise in unsynced) {
      await _collection.doc(exercise.id).set(
        exercise.copyWith(isSynced: true).toFirestore(),
        SetOptions(merge: true),
      );
    }
  }

  Future<List<Exercise>> getByClass(String classId) async {
    try {
      final snapshot = await _collection.where('classId', isEqualTo: classId).get();
      return snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Exercise>> getBySubject(String subjectId) async {
    try {
      final snapshot = await _collection.where('subjectId', isEqualTo: subjectId).get();
      return snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Exercise>> getByDueDate(DateTime date) async {
    try {
      final snapshot = await _collection
          .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
          .where('dueDate', isLessThan: Timestamp.fromDate(date.add(const Duration(days: 1))))
          .get();
      return snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
