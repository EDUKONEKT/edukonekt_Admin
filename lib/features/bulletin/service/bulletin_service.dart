import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/bulletin_model.dart';

class BulletinService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'bulletins';

  // Adds a new bulletin to Firestore
  Future<Bulletin?> addBulletin(Bulletin bulletin) async {
    try {
      final docRef = await _db.collection(_collection).add(bulletin.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Bulletin.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding bulletin: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding bulletin: $e');
    }
  }

  // Retrieves a bulletin by its Firestore ID
  Future<Bulletin?> getBulletinById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Bulletin.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting bulletin by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting bulletin by ID: $e');
    }
  }

  // Retrieves all bulletins
  Future<List<Bulletin>> getAllBulletins() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Bulletin.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all bulletins: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all bulletins: $e');
    }
  }

  // Retrieves bulletins for a specific student
  Future<List<Bulletin>> getBulletinsByStudent(String studentId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('studentId', isEqualTo: studentId)
          .get();
      return querySnapshot.docs.map((doc) => Bulletin.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting bulletins by student: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting bulletins by student: $e');
    }
  }

  // Retrieves bulletins for a specific class
  Future<List<Bulletin>> getBulletinsByClass(String classId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('classId', isEqualTo: classId)
          .get();
      return querySnapshot.docs.map((doc) => Bulletin.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting bulletins by class: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting bulletins by class: $e');
    }
  }

  // Retrieves bulletins for a specific academic year
  Future<List<Bulletin>> getBulletinsByAcademicYear(String academicYear) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('academicYear', isEqualTo: academicYear)
          .get();
      return querySnapshot.docs.map((doc) => Bulletin.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting bulletins by academic year: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting bulletins by academic year: $e');
    }
  }

  // Retrieves bulletins for a specific term
  Future<List<Bulletin>> getBulletinsByTerm(String term) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('term', isEqualTo: term)
          .get();
      return querySnapshot.docs.map((doc) => Bulletin.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting bulletins by term: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting bulletins by term: $e');
    }
  }

  // Updates an existing bulletin
  Future<void> updateBulletin(Bulletin bulletin) async {
    try {
      await _db.collection(_collection).doc(bulletin.id).update(bulletin.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating bulletin: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating bulletin: $e');
    }
  }

  // Deletes a bulletin by its ID
  Future<void> deleteBulletin(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting bulletin: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting bulletin: $e');
    }
  }
}