import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../core/models/alert_model.dart'; // Ensure the path is correct

class AlertService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'alerts';

  // Adds a new alert to Firestore
  Future<Alert?> addAlert(Alert alert) async {
    try {
      final docRef = await _db.collection(_collection).add(alert.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Alert.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding alert: $e');
    }
  }

  // Retrieves an alert by its Firestore ID
  Future<Alert?> getAlertById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Alert.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting alert by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting alert by ID: $e');
    }
  }

  // Retrieves all alerts
  Future<List<Alert>> getAllAlerts() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Alert.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all alerts: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all alerts: $e');
    }
  }

  // Retrieves alerts for a specific user
  Future<List<Alert>> getAlertsByUser(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) => Alert.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting alerts by user: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting alerts by user: $e');
    }
  }

  // Retrieves alerts by severity level
  Future<List<Alert>> getAlertsBySeverity(String severity) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('severity', isEqualTo: severity)
          .get();
      return querySnapshot.docs.map((doc) => Alert.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting alerts by severity: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting alerts by severity: $e');
    }
  }

  // Retrieves un-dismissed alerts
  Future<List<Alert>> getUnDismissedAlerts() async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('isDismissed', isEqualTo: false)
          .get();
      return querySnapshot.docs.map((doc) => Alert.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting un-dismissed alerts: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting un-dismissed alerts: $e');
    }
  }

  // Updates an existing alert
  Future<void> updateAlert(Alert alert) async {
    try {
      await _db.collection(_collection).doc(alert.id).update(alert.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating alert: $e');
    }
  }

  // Deletes an alert by its ID
  Future<void> deleteAlert(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting alert: $e');
    }
  }
}