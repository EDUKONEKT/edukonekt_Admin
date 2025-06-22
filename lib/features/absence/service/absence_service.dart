import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/absence_model.dart';

class AbsenceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'absences';

  // Adds a new absence record to Firestore
  Future<Absence?> addAbsence(Absence absence) async {
    try {
      final docRef = await _db.collection(_collection).add(absence.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Absence.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding absence: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding absence: $e');
    }
  }

  // Retrieves an absence record by its Firestore ID
  Future<Absence?> getAbsenceById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Absence.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting absence by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting absence by ID: $e');
    }
  }

  // Retrieves all absence records
  Future<List<Absence>> getAllAbsences() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Absence.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all absences: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all absences: $e');
    }
  }

  // Retrieves absence records for a specific student
  Future<List<Absence>> getAbsencesByStudent(String studentId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('studentId', isEqualTo: studentId)
          .get();
      return querySnapshot.docs.map((doc) => Absence.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting absences by student: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting absences by student: $e');
    }
  }

  // Retrieves absence records for a specific date
  Future<List<Absence>> getAbsencesByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _db
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();
      return querySnapshot.docs.map((doc) => Absence.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting absences by date: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting absences by date: $e');
    }
  }

  // Updates an existing absence record
  Future<void> updateAbsence(Absence absence) async {
    try {
      await _db.collection(_collection).doc(absence.id).update(absence.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating absence: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating absence: $e');
    }
  }

  // Deletes an absence record by its ID
  Future<void> deleteAbsence(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting absence: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting absence: $e');
    }
  }
}