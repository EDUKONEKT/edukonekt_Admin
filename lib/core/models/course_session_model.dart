import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseSession {
  String id;
  String classId;   // Clé étrangère vers Class
  String teacherId; // Clé étrangère vers Teacher
  String subjectId; // Clé étrangère vers Subject
  int dayOfWeek;    // 1: Lundi, 2: Mardi, ..., 7: Dimanche
  TimeOfDay startTime;
  TimeOfDay endTime;
  String academicYear; // "2023-2024"   // Date de fin de la récurrence

  DateTime createdAt;
  DateTime updatedAt;

  CourseSession({
    required this.id,
    required this.classId,
    required this.teacherId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.academicYear,
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
      startTime: _timeOfDayFromTimestamp(data['startTime']),
      endTime: _timeOfDayFromTimestamp(data['endTime']),
      academicYear: data['academicYear'] ?? '',
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
      'startTime': _timeOfDayToTimestamp(startTime),
      'endTime': endTime,
      'academicYear': academicYear,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper functions to handle TimeOfDay with Firestore (comme avant)
  static TimeOfDay _timeOfDayFromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } else {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  static Timestamp _timeOfDayToTimestamp(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }
}