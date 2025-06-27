import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeUtils {
  static TimeOfDay fromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final dt = timestamp.toDate();
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  static Timestamp toTimestamp(TimeOfDay time) {
    final now = DateTime.now();
    return Timestamp.fromDate(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  }
}

enum LessonStatus { pending, done, cancelled }

enum ExerciseStatus { draft, published, closed }

enum AbsenceStatus { pending, justified, confirmed }
