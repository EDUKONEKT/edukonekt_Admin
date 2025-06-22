import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String id;
  String userId; // Clé étrangère vers 'users'
  String content;
  DateTime timestamp;
  bool isRead;
  String type; // Type de notification (ex: "absence", "new_message")
  DateTime createdAt;
  DateTime updatedAt;

  Notification({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromFirestore(Map<String, dynamic> data, String id) {
    return Notification(
      id: id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      type: data['type'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'content': content,
      'timestamp': timestamp,
      'isRead': isRead,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}