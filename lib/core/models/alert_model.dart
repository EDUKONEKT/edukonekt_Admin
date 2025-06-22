import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  String id;
  String userId; // Clé étrangère vers 'users'
  String content;
  DateTime timestamp;
  String severity; // Niveau de gravité (ex: "info", "warning", "danger")
  bool isDismissed;
  DateTime createdAt;
  DateTime updatedAt;

  Alert({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.severity,
    required this.isDismissed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Alert.fromFirestore(Map<String, dynamic> data, String id) {
    return Alert(
      id: id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      severity: data['severity'] ?? 'info',
      isDismissed: data['isDismissed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'content': content,
      'timestamp': timestamp,
      'severity': severity,
      'isDismissed': isDismissed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}