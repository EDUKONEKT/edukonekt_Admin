import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/notification_model.dart'; // Ensure the path is correct

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'notifications';

  // Adds a new notification to Firestore
  Future<Notification?> addNotification(Notification notification) async {
    try {
      final docRef = await _db.collection(_collection).add(notification.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Notification.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding notification: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding notification: $e');
    }
  }

  // Retrieves a notification by its Firestore ID
  Future<Notification?> getNotificationById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Notification.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting notification by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting notification by ID: $e');
    }
  }

  // Retrieves all notifications
  Future<List<Notification>> getAllNotifications() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Notification.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all notifications: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all notifications: $e');
    }
  }

  // Retrieves notifications for a specific user
  Future<List<Notification>> getNotificationsByUser(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) => Notification.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting notifications by user: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting notifications by user: $e');
    }
  }

  // Retrieves unread notifications for a specific user
  Future<List<Notification>> getUnreadNotificationsByUser(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      return querySnapshot.docs.map((doc) => Notification.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting unread notifications by user: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting unread notifications by user: $e');
    }
  }

  // Retrieves notifications by type
  Future<List<Notification>> getNotificationsByType(String type) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('type', isEqualTo: type)
          .get();
      return querySnapshot.docs.map((doc) => Notification.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting notifications by type: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting notifications by type: $e');
    }
  }

  // Updates an existing notification
  Future<void> updateNotification(Notification notification) async {
    try {
      await _db.collection(_collection).doc(notification.id).update(notification.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating notification: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating notification: $e');
    }
  }

  // Deletes a notification by its ID
  Future<void> deleteNotification(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting notification: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting notification: $e');
    }
  }
}