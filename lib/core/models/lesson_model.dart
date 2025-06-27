// ✅ LessonStatus Enum
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/time_utils.dart';

enum LessonStatus { pending, done, cancelled }

class Lesson {
  final String id;
  final String courseSessionId;
  final String classId;
  final String subjectId;
  final String teacherId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String title;
  final String description;
  final LessonStatus status;
  final bool isSynced;
  final bool visibleToParents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.courseSessionId,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.status,
    required this.isSynced,
    required this.visibleToParents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromFirestore(Map<String, dynamic> data, String id) {
    return Lesson(
      id: id,
      courseSessionId: data['courseSessionId'] ?? '',
      classId: data['classId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      teacherId: data['teacherId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
     startTime: TimeUtils.fromTimestamp(data['startTime']),
      endTime: TimeUtils.fromTimestamp(data['endTime']),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: LessonStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => LessonStatus.pending,
      ),
      isSynced: data['isSynced'] ?? false,
      visibleToParents: data['visibleToParents'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseSessionId': courseSessionId,
      'classId': classId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'date': date,
      'startTime': TimeUtils.toTimestamp(startTime),
      'endTime': TimeUtils.toTimestamp(endTime),
      'title': title,
      'description': description,
      'status': status.name,
      'isSynced': isSynced,
      'visibleToParents': visibleToParents,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Lesson copyWith({
    String? id,
    String? courseSessionId,
    String? classId,
    String? subjectId,
    String? teacherId,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? title,
    String? description,
    LessonStatus? status,
    bool? isSynced,
    bool? visibleToParents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lesson(
      id: id ?? this.id,
      courseSessionId: courseSessionId ?? this.courseSessionId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      visibleToParents: visibleToParents ?? this.visibleToParents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
