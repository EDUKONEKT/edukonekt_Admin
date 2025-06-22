import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lesson {
  String id;
  String title;
  String description;
  String subjectId; // Clé étrangère vers 'subjects'
  String classId; // Clé étrangère vers 'classes'
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String teacherId; // Clé étrangère vers 'teachers'
  DateTime createdAt;
  DateTime updatedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.classId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.teacherId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromFirestore(Map<String, dynamic> data, String id) {
    return Lesson(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subjectId: data['subjectId'] ?? '',
      classId: data['classId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      startTime: _timeOfDayFromTimestamp(data['startTime']),
      endTime: _timeOfDayFromTimestamp(data['endTime']),
      teacherId: data['teacherId'] ?? '',
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
      'date': date,
      'startTime': _timeOfDayToTimestamp(startTime),
      'endTime': _timeOfDayToTimestamp(endTime),
      'teacherId': teacherId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper functions to handle TimeOfDay with Firestore
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