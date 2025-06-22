import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/lesson_model.dart';

class LessonService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'lessons';

  // Adds a new lesson to Firestore
  Future<Lesson?> addLesson(Lesson lesson) async {
    try {
      final docRef = await _db.collection(_collection).add(lesson.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Lesson.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding lesson: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding lesson: $e');
    }
  }

  // Retrieves a lesson by its Firestore ID
  Future<Lesson?> getLessonById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Lesson.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting lesson by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting lesson by ID: $e');
    }
  }

  // Retrieves all lessons
  Future<List<Lesson>> getAllLessons() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Lesson.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all lessons: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all lessons: $e');
    }
  }

  // Retrieves lessons by subjectId
  Future<List<Lesson>> getLessonsBySubject(String subjectId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('subjectId', isEqualTo: subjectId)
          .get();
      return querySnapshot.docs.map((doc) => Lesson.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting lessons by subject: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting lessons by subject: $e');
    }
  }

  // Retrieves lessons by classId
  Future<List<Lesson>> getLessonsByClass(String classId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('classId', isEqualTo: classId)
          .get();
      return querySnapshot.docs.map((doc) => Lesson.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting lessons by class: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting lessons by class: $e');
    }
  }

  // Retrieves lessons by teacherId
  Future<List<Lesson>> getLessonsByTeacher(String teacherId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('teacherId', isEqualTo: teacherId)
          .get();
      return querySnapshot.docs.map((doc) => Lesson.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting lessons by teacher: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting lessons by teacher: $e');
    }
  }

  // Retrieves lessons by date
  Future<List<Lesson>> getLessonsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _db
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();
      return querySnapshot.docs.map((doc) => Lesson.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting lessons by date: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting lessons by date: $e');
    }
  }

  // Updates an existing lesson
  Future<void> updateLesson(Lesson lesson) async {
    try {
      await _db.collection(_collection).doc(lesson.id).update(lesson.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating lesson: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating lesson: $e');
    }
  }

  // Deletes a lesson by its ID
  Future<void> deleteLesson(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting lesson: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting lesson: $e');
    }
  }
}