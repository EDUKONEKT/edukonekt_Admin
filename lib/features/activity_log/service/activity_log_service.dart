import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/activitylog_model.dart';// Ensure the path is correct

class ActivityLogService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'activity_logs';

  // Adds a new activity log entry to Firestore
  Future<ActivityLog?> addActivityLog(ActivityLog log) async {
    try {
      final docRef = await _db.collection(_collection).add(log.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? ActivityLog.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding activity log: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding activity log: $e');
    }
  }

  // Retrieves an activity log entry by its Firestore ID
  Future<ActivityLog?> getActivityLogById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? ActivityLog.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting activity log by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting activity log by ID: $e');
    }
  }

  // Retrieves all activity log entries
  Future<List<ActivityLog>> getAllActivityLogs() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => ActivityLog.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all activity logs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all activity logs: $e');
    }
  }

  // Retrieves activity log entries for a specific user
  Future<List<ActivityLog>> getActivityLogsByUser(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) => ActivityLog.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting activity logs by user: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting activity logs by user: $e');
    }
  }

  // Retrieves activity log entries from a specific source
  Future<List<ActivityLog>> getActivityLogsBySource(String source) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('source', isEqualTo: source)
          .get();
      return querySnapshot.docs.map((doc) => ActivityLog.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting activity logs by source: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting activity logs by source: $e');
    }
  }

  // Retrieves activity log entries for a specific date (or range)
  Future<List<ActivityLog>> getActivityLogsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _db
          .collection(_collection)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThanOrEqualTo: endOfDay)
          .get();
      return querySnapshot.docs.map((doc) => ActivityLog.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting activity logs by date: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting activity logs by date: $e');
    }
  }

  // Updates an existing activity log entry (Note: You might not need this, as logs are usually not updated)
  Future<void> updateActivityLog(ActivityLog log) async {
    try {
      await _db.collection(_collection).doc(log.id).update(log.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating activity log: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating activity log: $e');
    }
  }

  // Deletes an activity log entry (Note: You might not need this, as logs are usually kept for audit purposes)
  Future<void> deleteActivityLog(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting activity log: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting activity log: $e');
    }
  }
}