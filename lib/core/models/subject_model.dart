import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  String id;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subject.fromFirestore(Map<String, dynamic> data, String id) {
    return Subject(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}