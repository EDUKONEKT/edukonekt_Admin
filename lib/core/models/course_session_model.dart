import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseSession {
  final String id;
  final String classId;
  final String teacherId;
  final String subjectId;
  final int dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String academicYear;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseSession({
    required this.id,
    required this.classId,
    required this.teacherId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.academicYear,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseSession.fromFirestore(Map<String, dynamic> data, String id) {
    return CourseSession(
      id: id,
      classId: data['classId'] ?? '',
      teacherId: data['teacherId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      dayOfWeek: data['dayOfWeek'] ?? 1,
      startTime: _fromTimestamp(data['startTime']),
      endTime: _fromTimestamp(data['endTime']),
      academicYear: data['academicYear'] ?? '',
      isSynced: data['isSynced'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'classId': classId,
      'teacherId': teacherId,
      'subjectId': subjectId,
      'dayOfWeek': dayOfWeek,
      'startTime': _toTimestamp(startTime),
      'endTime': _toTimestamp(endTime),
      'academicYear': academicYear,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CourseSession copyWith({
    String? id,
    String? classId,
    String? teacherId,
    String? subjectId,
    int? dayOfWeek,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? academicYear,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseSession(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      subjectId: subjectId ?? this.subjectId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      academicYear: academicYear ?? this.academicYear,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static TimeOfDay _fromTimestamp(Timestamp? ts) {
    final dt = ts?.toDate() ?? DateTime.now();
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  static Timestamp _toTimestamp(TimeOfDay t) {
    final now = DateTime.now();
    return Timestamp.fromDate(DateTime(now.year, now.month, now.day, t.hour, t.minute));
  }
}
