import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/teacher_assignment_model.dart';


class TeacherAssignmentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'teacher_assignments';

  // Ajoute une nouvelle assignation d'enseignant à Firestore
  Future<TeacherAssignment?> addTeacherAssignment(TeacherAssignment assignment) async {
    try {
      final docRef = await _db.collection(_collection).add(assignment.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? TeacherAssignment.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de l\'ajout de l\'assignation : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de l\'ajout de l\'assignation : $e');
    }
  }

  // Récupère une assignation d'enseignant par son ID Firestore
  Future<TeacherAssignment?> getTeacherAssignmentById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? TeacherAssignment.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération de l\'assignation par ID : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération de l\'assignation par ID : $e');
    }
  }

  // Récupère toutes les assignations d'enseignants
  Future<List<TeacherAssignment>> getAllTeacherAssignments() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => TeacherAssignment.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération de toutes les assignations : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération de toutes les assignations : $e');
    }
  }

  // Récupère les assignations d'enseignant pour un enseignant spécifique
  Future<List<TeacherAssignment>> getTeacherAssignmentsByTeacher(String teacherId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('teacherId', isEqualTo: teacherId)
          .get();
      return querySnapshot.docs.map((doc) => TeacherAssignment.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération des assignations par enseignant : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération des assignations par enseignant : $e');
    }
  }

  // Récupère les assignations d'enseignant pour une matière spécifique
  Future<List<TeacherAssignment>> getTeacherAssignmentsBySubject(String subjectId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('subjectId', isEqualTo: subjectId)
          .get();
      return querySnapshot.docs.map((doc) => TeacherAssignment.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération des assignations par matière : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération des assignations par matière : $e');
    }
  }

  // Récupère les assignations d'enseignant pour une classe spécifique
  Future<List<TeacherAssignment>> getTeacherAssignmentsByClass(String classId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('classId', isEqualTo: classId)
          .get();
      return querySnapshot.docs.map((doc) => TeacherAssignment.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la récupération des assignations par classe : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération des assignations par classe : $e');
    }
  }

  // Met à jour une assignation d'enseignant existante
  Future<void> updateTeacherAssignment(TeacherAssignment assignment) async {
    try {
      await _db.collection(_collection).doc(assignment.id).update(assignment.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la mise à jour de l\'assignation : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la mise à jour de l\'assignation : $e');
    }
  }

  // Supprime une assignation d'enseignant par son ID
  Future<void> deleteTeacherAssignment(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Erreur Firebase lors de la suppression de l\'assignation : ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la suppression de l\'assignation : $e');
    }
  }
}