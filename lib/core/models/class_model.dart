import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  final String id;
  final String name;               // Ex: "6e A" (généré)
  final String level;              // Ex: "6e", "5e", ..., "Tle"
  final String section;            // Ex: "A", "B", "1"
  final String cycle;              // "cycle1" ou "cycle2"
  final String teacherId;          // UID du professeur principal
  final String installmentGridId;  // ID de la grille liée
  final String schoolId;
  final int studentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Class({
    required this.id,
    required this.name,
    required this.level,
    required this.section,
    required this.cycle,
    required this.teacherId,
    required this.installmentGridId,
    required this.schoolId,
    required this.studentCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Class.fromMap(Map<String, dynamic> map, String id) {
    return Class(
      id: id,
      name: map['name'],
      level: map['level'],
      section: map['section'],
      cycle: map['cycle'],
      teacherId: map['teacherId'],
      installmentGridId: map['installmentGridId'],
      schoolId: map['schoolId'],
      studentCount: map['studentCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
      'section': section,
      'cycle': cycle,
      'teacherId': teacherId,
      'installmentGridId': installmentGridId,
      'schoolId': schoolId,
      'studentCount': studentCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
