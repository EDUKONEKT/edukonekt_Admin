import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/time_utils.dart';

class Exercise {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String classId;
  final String teacherId;
  final DateTime dueDate;
  final String? lessonId;
  final ExerciseStatus status;
  final bool isSynced;
  final bool visibleToParents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
    required this.dueDate,
    required this.lessonId,
    required this.status,
    required this.isSynced,
    required this.visibleToParents,
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
      teacherId: data['teacherId'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      lessonId: data['lessonId'],
      status: ExerciseStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => ExerciseStatus.draft),
      isSynced: data['isSynced'] ?? false,
      visibleToParents: data['visibleToParents'] ?? false,
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
      'teacherId': teacherId,
      'dueDate': dueDate,
      'lessonId': lessonId,
      'status': status.name,
      'isSynced': isSynced,
      'visibleToParents': visibleToParents,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Exercise copyWith({
    String? id,
    String? title,
    String? description,
    String? subjectId,
    String? classId,
    String? teacherId,
    DateTime? dueDate,
    String? lessonId,
    ExerciseStatus? status,
    bool? isSynced,
    bool? visibleToParents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      dueDate: dueDate ?? this.dueDate,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      visibleToParents: visibleToParents ?? this.visibleToParents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}