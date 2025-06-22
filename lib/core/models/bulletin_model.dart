import 'package:cloud_firestore/cloud_firestore.dart';

class Bulletin {
  String id;
  String studentId; // Clé étrangère vers 'students'
  String classId; // Clé étrangère vers 'classes'
  String academicYear;
  String term; // Trimestre, Semestre
  double averageScore;
  DateTime createdAt;
  DateTime updatedAt;

  Bulletin({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.academicYear,
    required this.term,
    required this.averageScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bulletin.fromFirestore(Map<String, dynamic> data, String id) {
    return Bulletin(
      id: id,
      studentId: data['studentId'] ?? '',
      classId: data['classId'] ?? '',
      academicYear: data['academicYear'] ?? '',
      term: data['term'] ?? '',
      averageScore: (data['averageScore'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'classId': classId,
      'academicYear': academicYear,
      'term': term,
      'averageScore': averageScore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}