import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String id;
  String title;
  String description;
  String subjectId; // Clé étrangère vers 'subjects'
  String classId; // Clé étrangère vers 'classes'
  DateTime dueDate;
  DateTime createdAt;
  DateTime updatedAt;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.classId,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exercise.fromFirestore(Map<String, dynamic> data, String id) {
    return Exercise(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subjectId: data['subjectId'] ?? '',
      classId: data['classId'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
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
      'dueDate': dueDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}