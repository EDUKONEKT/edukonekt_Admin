import 'package:cloud_firestore/cloud_firestore.dart';

class Evaluation {
  String id;
  String title;
  String description;
  String subjectId; // Clé étrangère vers 'subjects'
  String classId; // Clé étrangère vers 'classes'
  DateTime date;
  double maxScore;
  DateTime createdAt;
  DateTime updatedAt;

  Evaluation({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.classId,
    required this.date,
    required this.maxScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Evaluation.fromFirestore(Map<String, dynamic> data, String id) {
    return Evaluation(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subjectId: data['subjectId'] ?? '',
      classId: data['classId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      maxScore: data['maxScore'] ?? 20.0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'classId': classId,
      'date': date,
      'maxScore': maxScore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}