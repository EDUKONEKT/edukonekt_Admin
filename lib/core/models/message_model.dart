import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String senderId; // Clé étrangère vers 'users'
  String receiverId; // Clé étrangère vers 'users'
  String content;
  DateTime timestamp;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromFirestore(Map<String, dynamic> data, String id) {
    return Message(
      id: id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
      'isRead': isRead,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}