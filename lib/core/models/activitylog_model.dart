import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  String id;
  String userId; // Clé étrangère vers 'users'
  String action;
  String description;
  String source; // Où l'action a été effectuée (ex: "student_management", "auth")
  DateTime timestamp;
  DateTime createdAt;
  DateTime updatedAt;

  ActivityLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.description,
    required this.source,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityLog.fromFirestore(Map<String, dynamic> data, String id) {
    return ActivityLog(
      id: id,
      userId: data['userId'] ?? '',
      action: data['action'] ?? '',
      description: data['description'] ?? '',
      source: data['source'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'action': action,
      'description': description,
      'source': source,
      'timestamp': timestamp,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}