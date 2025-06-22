import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/subject_model.dart';


class SubjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'subjects';

  // Ajoute une nouvelle matière à Firestore
  Future<Subject?> addSubject(Subject subject) async {
    try {
      final docRef = await _db.collection(_collection).add(subject.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Subject.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de l\'ajout de la matière : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de l\'ajout de la matière : $e');
    }
  }

  // Récupère une matière par son ID Firestore
  Future<Subject?> getSubjectById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Subject.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération de la matière par ID : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération de la matière par ID : $e');
    }
  }

  // Récupère toutes les matières
  Future<List<Subject>> getAllSubjects() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Subject.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération de toutes les matières : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération de toutes les matières : $e');
    }
  }

  // Met à jour une matière existante
  Future<void> updateSubject(Subject subject) async {
    try {
      await _db.collection(_collection).doc(subject.id).update(subject.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la mise à jour de la matière : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la mise à jour de la matière : $e');
    }
  }

  // Supprime une matière par son ID
  Future<void> deleteSubject(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la suppression de la matière : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la suppression de la matière : $e');
    }
  }
}