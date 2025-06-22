import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String id;
  String fullName;
  String gender;
  DateTime birthDate;
  String classId; // Clé étrangère vers la collection 'classes'
  String profilePictureUrl;
  String schoolFeeId; // Peut-être une clé étrangère vers une collection de frais de scolarité
  String parentId; 
  String specificities;// Clé étrangère vers la collection 'parents'
  bool isSynced;
  DateTime createdAt;
  DateTime updatedAt;

  Student({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.classId,
    required this.profilePictureUrl,
    required this.schoolFeeId,
    required this.parentId,
    required this.specificities,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromFirestore(Map<String, dynamic> data, String id) {
  final Timestamp? createdTs = data['createdAt'] as Timestamp?;
  final Timestamp? updatedTs = data['updatedAt'] as Timestamp?;

  return Student(
    id: id,
    fullName: data['fullName'] ?? '',
    gender: data['gender'] ?? '',
    birthDate: (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime(2000),
    classId: data['classId'] ?? '',
    profilePictureUrl: data['profilePictureUrl'] ?? '',
    schoolFeeId: data['schoolFeeId'] ?? '',
    parentId: data['parentId'] ?? '',
    specificities: data['specificities'] ?? '',
    isSynced: data['isSynced'] ?? false,
    createdAt: createdTs?.toDate() ?? DateTime.now(),
    updatedAt: updatedTs?.toDate() ?? DateTime.now(),
  );
}

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'gender': gender,
      'birthDate': birthDate,
      'classId': classId,
      'profilePictureUrl': profilePictureUrl,
      'schoolFeeId': schoolFeeId,
      'parentId': parentId,
      'specificities': specificities,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Student copyWith({
    String? parentId,
    bool? isSynced,
  }) =>
      Student(
        id: id,
        fullName: fullName,
        gender: gender,
        birthDate: birthDate,
        classId: classId,
        profilePictureUrl: profilePictureUrl,
        schoolFeeId: schoolFeeId,
        parentId: parentId ?? this.parentId,
        specificities: specificities,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}