import 'package:cloud_firestore/cloud_firestore.dart';

class Absence {
  String id;
  String studentId; // Clé étrangère vers 'students'
  DateTime date;
  String reason;
  bool isJustified;
  DateTime createdAt;
  DateTime updatedAt;

  Absence({
    required this.id,
    required this.studentId,
    required this.date,
    required this.reason,
    required this.isJustified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Absence.fromFirestore(Map<String, dynamic> data, String id) {
    return Absence(
      id: id,
      studentId: data['studentId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
      isJustified: data['isJustified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'date': date,
      'reason': reason,
      'isJustified': isJustified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}