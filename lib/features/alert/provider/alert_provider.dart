import 'package:flutter/material.dart';
import '../../../core/models/alert_model.dart';
import '../service/alert_service.dart';


class AlertProvider extends ChangeNotifier {
  final AlertService _alertService = AlertService();

  List<Alert> _alerts = [];
  List<Alert> get alerts => _alerts;

  Alert? _alert;
  Alert? get alert => _alert;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all alerts
  Future<void> fetchAlerts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _alerts = await _alertService.getAllAlerts();
    } catch (e) {
      _errorMessage = e.toString();
      _alerts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves an alert by its Firestore ID
  Future<void> getAlertById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _alert = await _alertService.getAlertById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _alert = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves alerts for a specific user
  Future<void> fetchAlertsByUser(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _alerts = await _alertService.getAlertsByUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
      _alerts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves alerts by severity level
  Future<void> fetchAlertsBySeverity(String severity) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _alerts = await _alertService.getAlertsBySeverity(severity);
    } catch (e) {
      _errorMessage = e.toString();
      _alerts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves un-dismissed alerts
  Future<void> fetchUnDismissedAlerts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _alerts = await _alertService.getUnDismissedAlerts();
    } catch (e) {
      _errorMessage = e.toString();
      _alerts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new alert
  Future<Alert?> addAlert(Alert alert) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newAlert = await _alertService.addAlert(alert);
      if (newAlert != null) {
        _alerts.add(newAlert);
        notifyListeners();
      }
      return newAlert;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing alert
  Future<void> updateAlert(Alert alert) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _alertService.updateAlert(alert);
      final index = _alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        _alerts[index] = alert;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes an alert
  Future<void> deleteAlert(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _alertService.deleteAlert(id);
      _alerts.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}