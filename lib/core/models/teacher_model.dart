import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  String id;
  String userId;
  String fullName;
  String phone;
  String email;
  String profilePictureUrl;
  List<String> subjects; // Liste des IDs des matières enseignées
  DateTime createdAt;
  DateTime updatedAt;

  Teacher({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.profilePictureUrl,
    required this.subjects,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Teacher.fromFirestore(Map<String, dynamic> data, String id) {
    return Teacher(
      id: id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      subjects: List<String>.from(data['subjects'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'subjects': subjects,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}