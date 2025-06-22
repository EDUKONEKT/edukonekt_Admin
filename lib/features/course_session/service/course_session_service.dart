import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/course_session_model.dart'; // Ensure the path is correct

class CourseSessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'course_sessions';

  // Adds a new course session to Firestore
  Future<CourseSession?> addCourseSession(CourseSession session) async {
    try {
      final docRef = await _db.collection(_collection).add(session.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? CourseSession.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding course session: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding course session: $e');
    }
  }

  // Retrieves a course session by its Firestore ID
  Future<CourseSession?> getCourseSessionById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? CourseSession.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting course session by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting course session by ID: $e');
    }
  }

  // Retrieves all course sessions
  Future<List<CourseSession>> getAllCourseSessions() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => CourseSession.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all course sessions: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all course sessions: $e');
    }
  }

  // Retrieves course sessions for a specific class
  Future<List<CourseSession>> getCourseSessionsByClass(String classId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('classId', isEqualTo: classId)
          .get();
      return querySnapshot.docs.map((doc) => CourseSession.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting course sessions by class: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting course sessions by class: $e');
    }
  }

  // Retrieves course sessions for a specific teacher
  Future<List<CourseSession>> getCourseSessionsByTeacher(String teacherId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('teacherId', isEqualTo: teacherId)
          .get();
      return querySnapshot.docs.map((doc) => CourseSession.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting course sessions by teacher: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting course sessions by teacher: $e');
    }
  }

  // Retrieves course sessions for a specific subject
  Future<List<CourseSession>> getCourseSessionsBySubject(String subjectId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('subjectId', isEqualTo: subjectId)
          .get();
      return querySnapshot.docs.map((doc) => CourseSession.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting course sessions by subject: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting course sessions by subject: $e');
    }
  }

  // Retrieves course sessions for a specific day of the week
  Future<List<CourseSession>> getCourseSessionsByDayOfWeek(int dayOfWeek) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('dayOfWeek', isEqualTo: dayOfWeek)
          .get();
      return querySnapshot.docs.map((doc) => CourseSession.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting course sessions by day of week: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting course sessions by day of week: $e');
    }
  }

  // Retrieves course sessions for a specific academic year
  Future<List<CourseSession>> getCourseSessionsByAcademicYear(String academicYear) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('academicYear', isEqualTo: academicYear)
          .get();
      return querySnapshot.docs.map((doc) => CourseSession.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting course sessions by academic year: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting course sessions by academic year: $e');
    }
  }

  // Updates an existing course session
  Future<void> updateCourseSession(CourseSession session) async {
    try {
      await _db.collection(_collection).doc(session.id).update(session.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating course session: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating course session: $e');
    }
  }

  // Deletes a course session by its ID
  Future<void> deleteCourseSession(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting course session: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting course session: $e');
    }
  }
}