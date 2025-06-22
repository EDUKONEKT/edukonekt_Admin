import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String studentId; // Clé étrangère vers 'students'
  String evaluationId; // Clé étrangère vers 'evaluations'
  double score;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.studentId,
    required this.evaluationId,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      studentId: data['studentId'] ?? '',
      evaluationId: data['evaluationId'] ?? '',
      score: (data['score'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'evaluationId': evaluationId,
      'score': score,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}