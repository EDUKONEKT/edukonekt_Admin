import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/message_model.dart'; // Ensure the path is correct

class MessageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'messages';

  // Adds a new message to Firestore
  Future<Message?> addMessage(Message message) async {
    try {
      final docRef = await _db.collection(_collection).add(message.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Message.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding message: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding message: $e');
    }
  }

  // Retrieves a message by its Firestore ID
  Future<Message?> getMessageById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Message.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting message by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting message by ID: $e');
    }
  }

  // Retrieves all messages
  Future<List<Message>> getAllMessages() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Message.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all messages: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all messages: $e');
    }
  }

  // Retrieves messages sent by a specific user
  Future<List<Message>> getMessagesBySender(String senderId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('senderId', isEqualTo: senderId)
          .get();
      return querySnapshot.docs.map((doc) => Message.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting messages by sender: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting messages by sender: $e');
    }
  }

  // Retrieves messages received by a specific user
  Future<List<Message>> getMessagesByReceiver(String receiverId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('receiverId', isEqualTo: receiverId)
          .get();
      return querySnapshot.docs.map((doc) => Message.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting messages by receiver: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting messages by receiver: $e');
    }
  }

  // Retrieves messages between two specific users
  Future<List<Message>> getMessagesBetweenUsers(String userId1, String userId2) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('senderId', whereIn: [userId1, userId2])
          .where('receiverId', whereIn: [userId1, userId2])
          .get();

      // Filter the results in Dart to get only messages where sender and receiver are the two users
      final filteredMessages = querySnapshot.docs.map((doc) => Message.fromFirestore(doc.data(), doc.id))
          .where((message) =>
              (message.senderId == userId1 && message.receiverId == userId2) ||
              (message.senderId == userId2 && message.receiverId == userId1))
          .toList();

      return filteredMessages;

    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting messages between users: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting messages between users: $e');
    }
  }

  // Updates an existing message
  Future<void> updateMessage(Message message) async {
    try {
      await _db.collection(_collection).doc(message.id).update(message.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating message: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating message: $e');
    }
  }

  // Deletes a message by its ID
  Future<void> deleteMessage(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting message: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting message: $e');
    }
  }
}