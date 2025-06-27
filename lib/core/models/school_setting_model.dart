import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edukonekt_admin/core/models/daysetting.dart';


class SchoolSetting {
  final String id;
  final String schoolId;
  final Map<int, DaySetting> dailySettings; // 1 (lundi) → 7 (dimanche)
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  SchoolSetting({
    required this.id,
    required this.schoolId,
    required this.dailySettings,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SchoolSetting.fromFirestore(Map<String, dynamic> data, String id) {
    final settingsMap = <int, DaySetting>{};
    final raw = Map<String, dynamic>.from(data['dailySettings'] ?? {});
    for (final entry in raw.entries) {
      final day = int.tryParse(entry.key);
      if (day != null) {
        settingsMap[day] = DaySetting.fromMap(Map<String, dynamic>.from(entry.value));
      }
    }

    return SchoolSetting(
      id: id,
      schoolId: data['schoolId'] ?? '',
      dailySettings: settingsMap,
      isSynced: data['isSynced'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'schoolId': schoolId,
      'dailySettings': dailySettings.map((key, value) => MapEntry(key.toString(), value.toMap())),
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  SchoolSetting copyWith({
    String? id,
    String? schoolId,
    Map<int, DaySetting>? dailySettings,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SchoolSetting(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      dailySettings: dailySettings ?? this.dailySettings,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
