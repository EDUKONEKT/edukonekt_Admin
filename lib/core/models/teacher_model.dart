import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String gender;
  final String profilePictureUrl;
  final List<String> subjects;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool requiresAccount;

  Teacher({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.profilePictureUrl,
    required this.subjects,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
    required this.requiresAccount,
  });

  factory Teacher.fromFirestore(Map<String, dynamic> data, String id) {
    final Timestamp? createdTs = data['createdAt'] as Timestamp?;
    final Timestamp? updatedTs = data['updatedAt'] as Timestamp?;

    return Teacher(
      id: id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'] ?? 'm',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      subjects: List<String>.from(data['subjects'] ?? []),
      isSynced: data['isSynced'] ?? false,
      createdAt: createdTs?.toDate() ?? DateTime.now(),
      updatedAt: updatedTs?.toDate() ?? DateTime.now(),
      requiresAccount: data['requiresAccount'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
      'subjects': subjects,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'requiresAccount': requiresAccount,
    };
  }

  Teacher copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phone,
    String? email,
    String? gender,
    String? profilePictureUrl,
    List<String>? subjects,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? requiresAccount,
  }) {
    return Teacher(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      subjects: subjects ?? this.subjects,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      requiresAccount: requiresAccount ?? this.requiresAccount,
    );
  }
}
