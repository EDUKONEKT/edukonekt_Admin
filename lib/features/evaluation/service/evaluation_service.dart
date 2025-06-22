import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/evaluation_model.dart'; // Ensure the path is correct

class EvaluationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'evaluations';

  // Adds a new evaluation to Firestore
  Future<Evaluation?> addEvaluation(Evaluation evaluation) async {
    try {
      final docRef = await _db.collection(_collection).add(evaluation.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Evaluation.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding evaluation: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding evaluation: $e');
    }
  }

  // Retrieves an evaluation by its Firestore ID
  Future<Evaluation?> getEvaluationById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Evaluation.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting evaluation by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting evaluation by ID: $e');
    }
  }

  // Retrieves all evaluations
  Future<List<Evaluation>> getAllEvaluations() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Evaluation.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all evaluations: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all evaluations: $e');
    }
  }

  // Retrieves evaluations for a specific subject
  Future<List<Evaluation>> getEvaluationsBySubject(String subjectId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('subjectId', isEqualTo: subjectId)
          .get();
      return querySnapshot.docs.map((doc) => Evaluation.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting evaluations by subject: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting evaluations by subject: $e');
    }
  }

  // Retrieves evaluations for a specific class
  Future<List<Evaluation>> getEvaluationsByClass(String classId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('classId', isEqualTo: classId)
          .get();
      return querySnapshot.docs.map((doc) => Evaluation.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting evaluations by class: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting evaluations by class: $e');
    }
  }

  // Retrieves evaluations on a specific date
  Future<List<Evaluation>> getEvaluationsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _db
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();
      return querySnapshot.docs.map((doc) => Evaluation.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting evaluations by date: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting evaluations by date: $e');
    }
  }

  // Updates an existing evaluation
  Future<void> updateEvaluation(Evaluation evaluation) async {
    try {
      await _db.collection(_collection).doc(evaluation.id).update(evaluation.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating evaluation: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating evaluation: $e');
    }
  }

  // Deletes an evaluation by its ID
  Future<void> deleteEvaluation(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting evaluation: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting evaluation: $e');
    }
  }
}