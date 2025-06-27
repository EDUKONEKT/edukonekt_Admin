import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'break_slot_model.dart';

class DaySetting {
  final bool isWorkingDay;
  final TimeOfDay? startHour;
  final TimeOfDay? endHour;
  final List<BreakSlot> breaks;

  DaySetting({
    required this.isWorkingDay,
    required this.startHour,
    required this.endHour,
    required this.breaks,
  });

  factory DaySetting.empty() => DaySetting(
        isWorkingDay: false,
        startHour: null,
        endHour: null,
        breaks: [],
      );

  DaySetting copyWith({
    bool? isWorkingDay,
    TimeOfDay? startHour,
    TimeOfDay? endHour,
    List<BreakSlot>? breaks,
  }) {
    return DaySetting(
      isWorkingDay: isWorkingDay ?? this.isWorkingDay,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      breaks: breaks ?? this.breaks,
    );
  }

  /// 🔁 Convertit une Map Firestore → DaySetting
  factory DaySetting.fromMap(Map<String, dynamic> data) {
    return DaySetting(
      isWorkingDay: data['isWorkingDay'] ?? false,
      startHour: data['startHour'] != null
          ? BreakSlot.fromTimestamp(data['startHour'])
          : null,
      endHour: data['endHour'] != null
          ? BreakSlot.fromTimestamp(data['endHour'])
          : null,
      breaks: (data['breaks'] as List<dynamic>? ?? [])
          .map((e) => BreakSlot.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  /// 🔁 Convertit DaySetting → Map Firestore
  Map<String, dynamic> toMap() {
    return {
      'isWorkingDay': isWorkingDay,
      'startHour': startHour != null ? BreakSlot.toTimestamp(startHour!) : null,
      'endHour': endHour != null ? BreakSlot.toTimestamp(endHour!) : null,
      'breaks': breaks.map((b) => b.toMap()).toList(),
    };
  }
}
