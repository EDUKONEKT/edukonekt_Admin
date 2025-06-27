import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/models/absence_model.dart';
import '../service/absence_service.dart';

class AbsenceProvider extends ChangeNotifier {
  late AbsenceService _service;
  final Logger _log = Logger();

  final List<Absence> _absences = [];
  bool _isLoading = false;
  String? _error;
  bool _ready = false;
  StreamSubscription? _sub;

  List<Absence> get absences => List.unmodifiable(_absences);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get ready => _ready;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _service = AbsenceService(schoolId: schoolId);
    await _getOnce();
    _listenToAbsences();
  }

  Future<void> _getOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await _service.getAll();
      _absences
        ..clear()
        ..addAll(data);

      _ready = true;
    } catch (e, stack) {
      _error = e.toString();
      _log.e('AbsenceProvider initial load error', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToAbsences() {
    _sub?.cancel();
    _sub = _service.ref.snapshots().listen(
      (snapshot) {
        _absences
          ..clear()
          ..addAll(snapshot.docs.map((doc) => Absence.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id)));

        _error = null;
        notifyListeners();
      },
      onError: (e, stack) {
        _error = e.toString();
        _log.e('AbsenceProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      },
    );
  }

  // ---------- CRUD ----------
  Future<void> addAbsence(Absence absence) async {
    try {
      await _service.addAbsence(absence);
    } catch (e, stack) {
      _log.e('Erreur addAbsence', error: e, stackTrace: stack);
    }
  }

  Future<void> updateAbsence(Absence absence) async {
    try {
      await _service.updateAbsence(absence);
    } catch (e, stack) {
      _log.e('Erreur updateAbsence', error: e, stackTrace: stack);
    }
  }

  Future<void> deleteAbsence(String id) async {
    try {
      await _service.deleteAbsence(id);
    } catch (e, stack) {
      _log.e('Erreur deleteAbsence', error: e, stackTrace: stack);
    }
  }

  Future<void> syncPendingAbsences() async {
    final unsynced = _absences.where((a) => !a.isSynced).toList();
    if (unsynced.isNotEmpty) {
      await _service.sync(unsynced);
    }
  }

  // ---------- FILTERS ----------
  List<Absence> getByStudent(String studentId) {
    return _absences.where((a) => a.studentId == studentId).toList();
  }

  List<Absence> getByDate(DateTime date) {
    return _absences.where((a) =>
        a.date.year == date.year &&
        a.date.month == date.month &&
        a.date.day == date.day).toList();
  }

  List<Absence> getByJustification(bool justified) {
    return _absences.where((a) => a.isJustified == justified).toList();
  }

  Absence? getById(String id) {
    try {
      return _absences.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------- CLEANUP ----------
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
