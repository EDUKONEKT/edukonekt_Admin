import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/models/school_setting_model.dart';
import '../../core/models/break_slot_model.dart';
import '../../core/models/daysetting.dart';
import 'school_setting_service.dart';

class SchoolSettingProvider with ChangeNotifier {
  late final SchoolSettingService _service;

  SchoolSetting? _setting;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;

  SchoolSetting? get setting => _setting;
  bool get isLoading => _isLoading;
  String? get error => _error;
  SchoolSettingService get service => _service;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _service = SchoolSettingService(schoolId);
    await getSettingOnce();
    _listenToSetting();
  }

  // ---------- GET ----------
  Future<void> getSettingOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final setting = await _service.getOnce();
      if (setting != null) {
        _setting = setting;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToSetting() {
    _subscription?.cancel();
    _subscription = _service.ref.snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          _setting = SchoolSetting.fromFirestore(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          );
          _error = null;
          notifyListeners();
        }
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  // ---------- UPDATE ----------
  Future<void> updateSetting(SchoolSetting updated) async {
    try {
      await _service.update(updated);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void updateDaySetting(int day, DaySetting setting) {
    if (_setting == null) return;

    final updatedDays = Map<int, DaySetting>.from(_setting!.dailySettings);
    updatedDays[day] = setting;

    _setting = _setting!.copyWith(
      dailySettings: updatedDays,
      updatedAt: DateTime.now(),
    );
    notifyListeners();

    _service.update(_setting!); // push async
  }

  void toggleWorkingDay(int day, bool enabled) {
    if (_setting == null) return;
    final current = _setting!.dailySettings[day] ?? DaySetting.empty();
    updateDaySetting(day, current.copyWith(isWorkingDay: enabled));
  }

  void setStartHour(int day, TimeOfDay time) {
    if (_setting == null) return;
    final current = _setting!.dailySettings[day] ?? DaySetting.empty();
    updateDaySetting(day, current.copyWith(startHour: time));
  }

  void setEndHour(int day, TimeOfDay time) {
    if (_setting == null) return;
    final current = _setting!.dailySettings[day] ?? DaySetting.empty();
    updateDaySetting(day, current.copyWith(endHour: time));
  }

  void setBreaks(int day, List<BreakSlot> breaks) {
    if (_setting == null) return;
    final current = _setting!.dailySettings[day] ?? DaySetting.empty();
    updateDaySetting(day, current.copyWith(breaks: breaks));
  }

  void addBreak(int day, BreakSlot newBreak) {
    if (_setting == null) return;
    final current = _setting!.dailySettings[day] ?? DaySetting.empty();
    final updated = List<BreakSlot>.from(current.breaks)..add(newBreak);
    updateDaySetting(day, current.copyWith(breaks: updated));
  }

  void removeBreak(int day, int index) {
    if (_setting == null) return;
    final current = _setting!.dailySettings[day] ?? DaySetting.empty();
    final updated = List<BreakSlot>.from(current.breaks)..removeAt(index);
    updateDaySetting(day, current.copyWith(breaks: updated));
  }

  List<int> getWorkingDays() {
    if (_setting == null) return [];
    return _setting!.dailySettings.entries
        .where((e) => e.value.isWorkingDay)
        .map((e) => e.key)
        .toList();
  }

  ({TimeOfDay? start, TimeOfDay? end, List<BreakSlot> breaks}) getDayConfig(int day) {
    final config = _setting?.dailySettings[day] ?? DaySetting.empty();
    return (
      start: config.startHour,
      end: config.endHour,
      breaks: config.breaks,
    );
  }

  // ---------- CLEAN ----------
  void clear() {
    _subscription?.cancel();
    _subscription = null;
    _setting = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
