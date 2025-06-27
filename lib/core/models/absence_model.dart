import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/time_utils.dart';

class Absence {
  final String id;
  final String studentId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double totHours;
  final String reason;
  final bool isJustified;
  final String? lessonId;
  final String? classId;
  final AbsenceStatus status;
  final bool isSynced;
  final bool visibleToParents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Absence({
    required this.id,
    required this.studentId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totHours,
    required this.reason,
    required this.isJustified,
    required this.lessonId,
    required this.classId,
    required this.status,
    required this.isSynced,
    required this.visibleToParents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Absence.fromFirestore(Map<String, dynamic> data, String id) {
    return Absence(
      id: id,
      studentId: data['studentId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      startTime: TimeUtils.fromTimestamp(data['startTime']),
      endTime: TimeUtils.fromTimestamp(data['endTime']),
      totHours: (data['totHours'] ?? 0).toDouble(),
      reason: data['reason'] ?? '',
      isJustified: data['isJustified'] ?? false,
      lessonId: data['lessonId'],
      classId: data['classId'],
      status: AbsenceStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => AbsenceStatus.pending),
      isSynced: data['isSynced'] ?? false,
      visibleToParents: data['visibleToParents'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'date': date,
      'startTime': TimeUtils.toTimestamp(startTime),
      'endTime': TimeUtils.toTimestamp(endTime),
      'totHours': totHours,
      'reason': reason,
      'isJustified': isJustified,
      'lessonId': lessonId,
      'classId': classId,
      'status': status.name,
      'isSynced': isSynced,
      'visibleToParents': visibleToParents,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Absence copyWith({
    String? id,
    String? studentId,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    double? totHours,
    String? reason,
    bool? isJustified,
    String? lessonId,
    String? classId,
    AbsenceStatus? status,
    bool? isSynced,
    bool? visibleToParents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Absence(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totHours: totHours ?? this.totHours,
      reason: reason ?? this.reason,
      isJustified: isJustified ?? this.isJustified,
      lessonId: lessonId ?? this.lessonId,
      classId: classId ?? this.classId,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      visibleToParents: visibleToParents ?? this.visibleToParents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}