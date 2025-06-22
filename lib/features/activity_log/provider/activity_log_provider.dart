import 'package:flutter/material.dart';

import '../../../core/models/activitylog_model.dart';
import '../service/activity_log_service.dart';

class ActivityLogProvider extends ChangeNotifier {
  final ActivityLogService _activityLogService = ActivityLogService();

  List<ActivityLog> _activityLogs = [];
  List<ActivityLog> get activityLogs => _activityLogs;

  ActivityLog? _activityLog;
  ActivityLog? get activityLog => _activityLog;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all activity log entries
  Future<void> fetchActivityLogs() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _activityLogs = await _activityLogService.getAllActivityLogs();
    } catch (e) {
      _errorMessage = e.toString();
      _activityLogs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves an activity log entry by its Firestore ID
  Future<void> getActivityLogById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _activityLog = await _activityLogService.getActivityLogById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _activityLog = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves activity log entries for a specific user
  Future<void> fetchActivityLogsByUser(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _activityLogs = await _activityLogService.getActivityLogsByUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
      _activityLogs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves activity log entries from a specific source
  Future<void> fetchActivityLogsBySource(String source) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _activityLogs = await _activityLogService.getActivityLogsBySource(source);
    } catch (e) {
      _errorMessage = e.toString();
      _activityLogs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves activity log entries for a specific date (or range)
  Future<void> fetchActivityLogsByDate(DateTime date) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _activityLogs = await _activityLogService.getActivityLogsByDate(date);
    } catch (e) {
      _errorMessage = e.toString();
      _activityLogs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new activity log entry
  Future<ActivityLog?> addActivityLog(ActivityLog log) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newActivityLog = await _activityLogService.addActivityLog(log);
      if (newActivityLog != null) {
        _activityLogs.add(newActivityLog);
        notifyListeners();
      }
      return newActivityLog;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing activity log entry (Consider if you really need this)
  Future<void> updateActivityLog(ActivityLog log) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _activityLogService.updateActivityLog(log);
      final index = _activityLogs.indexWhere((l) => l.id == log.id);
      if (index != -1) {
        _activityLogs[index] = log;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes an activity log entry (Consider if you really need this)
  Future<void> deleteActivityLog(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _activityLogService.deleteActivityLog(id);
      _activityLogs.removeWhere((l) => l.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}