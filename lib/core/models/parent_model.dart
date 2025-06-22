import 'package:cloud_firestore/cloud_firestore.dart';

class Parent {
  String id;
  String userId; 
  String fatherfullName;
  String motherfullName;
  String tutorfullName;
  String fatherPhone;
  String motherPhone;
  String tutorPhone;
  String fatherAddress;
  String motherAddress;
  String tutorAddress;
  bool isSynced;
  DateTime createdAt;
  DateTime updatedAt;

  Parent({
    required this.id,
    required this.userId,
    required this.fatherfullName,
    required this.motherfullName,
    required this.tutorfullName,
    required this.fatherPhone,
    required this.motherPhone,
    required this.tutorPhone,
    required this.fatherAddress,
    required this.motherAddress,
    required this.tutorAddress,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Parent.fromFirestore(Map<String, dynamic> data, String id) {
  final Timestamp? createdTs = data['createdAt'] as Timestamp?;
  final Timestamp? updatedTs = data['updatedAt'] as Timestamp?;

  return Parent(
    id: id,
    userId: data['userId'] ?? '',
    fatherfullName: data['fatherfullName'] ?? '',
    motherfullName: data['motherfullName'] ?? '',
    tutorfullName: data['tutorfullName'] ?? '',
    fatherPhone: data['fatherPhone'] ?? '',
    motherPhone: data['motherPhone'] ?? '',
    tutorPhone: data['tutorPhone'] ?? '',
    fatherAddress: data['fatherAddress'] ?? '',
    motherAddress: data['motherAddress'] ?? '',
    tutorAddress: data['tutorAddress'] ?? '',
    isSynced: data['isSynced'] ?? false,
    createdAt: createdTs?.toDate() ?? DateTime.now(),
    updatedAt: updatedTs?.toDate() ?? DateTime.now(),
  );
}


  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fatherfullName': fatherfullName,
      'motherfullName':motherfullName,
      'tutorfullName':tutorfullName,
      'fatherPhone' : fatherPhone,
      'motherPhone' : motherPhone,
      'tutorPhone' : tutorPhone,
      'fatherAddress': fatherAddress,
      'motherAddress': motherAddress,
      'tutorAddress' : tutorAddress,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  
  Parent copyWith({bool? isSynced}) => Parent(
        id: id,
        userId: userId,
        fatherfullName: fatherfullName,
        motherfullName: motherfullName,
        tutorfullName: tutorfullName,
        fatherPhone: fatherPhone,
        motherPhone: motherPhone,
        tutorPhone: tutorPhone,
        fatherAddress: fatherAddress,
        motherAddress: motherAddress,
        tutorAddress: tutorAddress,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

