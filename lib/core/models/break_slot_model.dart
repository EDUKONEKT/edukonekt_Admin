import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BreakSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  BreakSlot({
    required this.startTime,
    required this.endTime,
  });

  factory BreakSlot.fromMap(Map<String, dynamic> data) {
    return BreakSlot(
      startTime: fromTimestamp(data['startTime']),
      endTime: fromTimestamp(data['endTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': toTimestamp(startTime),
      'endTime': toTimestamp(endTime),
    };
  }

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
