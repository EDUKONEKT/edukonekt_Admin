import 'package:flutter/material.dart';
import '../../../core/models/absence_model.dart';
import '../service/absence_service.dart'; // Ensure the path is correct

class AbsenceProvider extends ChangeNotifier {
  final AbsenceService _absenceService = AbsenceService();

  List<Absence> _absences = [];
  List<Absence> get absences => _absences;

  Absence? _absence;
  Absence? get absence => _absence;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all absence records
  Future<void> fetchAbsences() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _absences = await _absenceService.getAllAbsences();
    } catch (e) {
      _errorMessage = e.toString();
      _absences = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves an absence record by its Firestore ID
  Future<void> getAbsenceById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _absence = await _absenceService.getAbsenceById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _absence = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves absence records for a specific student
  Future<void> fetchAbsencesByStudent(String studentId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _absences = await _absenceService.getAbsencesByStudent(studentId);
    } catch (e) {
      _errorMessage = e.toString();
      _absences = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves absence records for a specific date
  Future<void> fetchAbsencesByDate(DateTime date) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _absences = await _absenceService.getAbsencesByDate(date);
    } catch (e) {
      _errorMessage = e.toString();
      _absences = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new absence record
  Future<Absence?> addAbsence(Absence absence) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newAbsence = await _absenceService.addAbsence(absence);
      if (newAbsence != null) {
        _absences.add(newAbsence);
        notifyListeners();
      }
      return newAbsence;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing absence record
  Future<void> updateAbsence(Absence absence) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _absenceService.updateAbsence(absence);
      final index = _absences.indexWhere((a) => a.id == absence.id);
      if (index != -1) {
        _absences[index] = absence;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes an absence record
  Future<void> deleteAbsence(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _absenceService.deleteAbsence(id);
      _absences.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}