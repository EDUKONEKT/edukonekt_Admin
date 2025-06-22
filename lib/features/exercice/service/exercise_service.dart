import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/exercise_model.dart'; // Ensure the path is correct

class ExerciseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'exercises';

  // Adds a new exercise to Firestore
  Future<Exercise?> addExercise(Exercise exercise) async {
    try {
      final docRef = await _db.collection(_collection).add(exercise.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Exercise.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding exercise: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding exercise: $e');
    }
  }

  // Retrieves an exercise by its Firestore ID
  Future<Exercise?> getExerciseById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Exercise.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting exercise by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting exercise by ID: $e');
    }
  }

  // Retrieves all exercises
  Future<List<Exercise>> getAllExercises() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Exercise.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all exercises: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all exercises: $e');
    }
  }

  // Retrieves exercises for a specific subject
  Future<List<Exercise>> getExercisesBySubject(String subjectId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('subjectId', isEqualTo: subjectId)
          .get();
      return querySnapshot.docs.map((doc) => Exercise.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting exercises by subject: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting exercises by subject: $e');
    }
  }

  // Retrieves exercises for a specific class
  Future<List<Exercise>> getExercisesByClass(String classId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('classId', isEqualTo: classId)
          .get();
      return querySnapshot.docs.map((doc) => Exercise.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting exercises by class: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting exercises by class: $e');
    }
  }

  // Retrieves exercises due on a specific date
  Future<List<Exercise>> getExercisesByDueDate(DateTime dueDate) async {
    try {
      final startOfDay = DateTime(dueDate.year, dueDate.month, dueDate.day, 0, 0, 0);
      final endOfDay = DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59);

      final querySnapshot = await _db
          .collection(_collection)
          .where('dueDate', isGreaterThanOrEqualTo: startOfDay)
          .where('dueDate', isLessThanOrEqualTo: endOfDay)
          .get();
      return querySnapshot.docs.map((doc) => Exercise.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting exercises by due date: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting exercises by due date: $e');
    }
  }

  // Updates an existing exercise
  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _db.collection(_collection).doc(exercise.id).update(exercise.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating exercise: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating exercise: $e');
    }
  }

  // Deletes an exercise by its ID
  Future<void> deleteExercise(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting exercise: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting exercise: $e');
    }
  }
}