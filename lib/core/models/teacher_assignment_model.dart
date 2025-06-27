import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAssignment {
  final String id;
  final String teacherId;
  final String subjectId;
  final String classId;
  final String academicYear;
  final String term;
  final bool isActive;
  final bool isSynced;
  final bool visibleToTeacher;
  final DateTime createdAt;
  final DateTime updatedAt;

  TeacherAssignment({
    required this.id,
    required this.teacherId,
    required this.subjectId,
    required this.classId,
    required this.academicYear,
    required this.term,
    required this.isActive,
    required this.isSynced,
    required this.visibleToTeacher,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherAssignment.fromFirestore(Map<String, dynamic> data, String id) {
    return TeacherAssignment(
      id: id,
      teacherId: data['teacherId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      classId: data['classId'] ?? '',
      academicYear: data['academicYear'] ?? '',
      term: data['term'] ?? '',
      isActive: data['isActive'] ?? true,
      isSynced: data['isSynced'] ?? false,
      visibleToTeacher: data['visibleToTeacher'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teacherId': teacherId,
      'subjectId': subjectId,
      'classId': classId,
      'academicYear': academicYear,
      'term': term,
      'isActive': isActive,
      'isSynced': isSynced,
      'visibleToTeacher': visibleToTeacher,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TeacherAssignment copyWith({
    String? id,
    String? teacherId,
    String? subjectId,
    String? classId,
    String? academicYear,
    String? term,
    bool? isActive,
    bool? isSynced,
    bool? visibleToTeacher,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeacherAssignment(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      subjectId: subjectId ?? this.subjectId,
      classId: classId ?? this.classId,
      academicYear: academicYear ?? this.academicYear,
      term: term ?? this.term,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      visibleToTeacher: visibleToTeacher ?? this.visibleToTeacher,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
