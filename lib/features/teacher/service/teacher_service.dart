import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/teacher_model.dart';

class TeacherService {
  final CollectionReference teachersRef =
      FirebaseFirestore.instance.collection('teachers');

  Future<void> addTeacher(Teacher teacher) async {
    try {
      await teachersRef.doc(teacher.id).set(teacher.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    try {
      await teachersRef.doc(teacher.id).update(teacher.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  Future<void> deleteTeacher(String id) async {
    try {
      await teachersRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  Future<List<Teacher>> getAllTeachers() async {
    try {
      final snapshot = await teachersRef.get();
      return snapshot.docs.map((doc) => Teacher.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  Future<Teacher?> getTeacherById(String id) async {
    try {
      final doc = await teachersRef.doc(id).get();
      if (doc.exists) {
        return Teacher.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  Future<List<Teacher>> getTeachersBySubject(String subjectId) async {
    try {
      final snapshot = await teachersRef.where('subjects', arrayContains: subjectId).get();
      return snapshot.docs.map((doc) => Teacher.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }
}