import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/models/teacher_assignment_model.dart';
import '../service/teacher_assignment_service.dart';

class TeacherAssignmentProvider extends ChangeNotifier {
  late TeacherAssignmentService _service;
  final Logger _log = Logger();

  final List<TeacherAssignment> _assignments = [];
  bool _isLoading = false;
  String? _error;
  bool _ready = false;
  StreamSubscription? _sub;

  List<TeacherAssignment> get assignments => List.unmodifiable(_assignments);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get ready => _ready;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _service = TeacherAssignmentService(schoolId: schoolId);
    await _getOnce();
    _listenToAssignments();
  }

  Future<void> _getOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await _service.getAll();
      _assignments
        ..clear()
        ..addAll(data);

      _ready = true;
    } catch (e, stack) {
      _error = e.toString();
      _log.e('TeacherAssignmentProvider init error', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToAssignments() {
    _sub?.cancel();
    _sub = _service.ref.snapshots().listen(
      (snapshot) {
        _assignments
          ..clear()
          ..addAll(snapshot.docs.map((doc) => TeacherAssignment.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id)));

        _error = null;
        notifyListeners();
      },
      onError: (e, stack) {
        _error = e.toString();
        _log.e('TeacherAssignmentProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      },
    );
  }

  // ---------- CRUD ----------
  Future<void> addAssignment(TeacherAssignment assignment) async {
    try {
      await _service.addAssignment(assignment);
    } catch (e, stack) {
      _log.e('Erreur addAssignment', error: e, stackTrace: stack);
    }
  }

  Future<void> updateAssignment(TeacherAssignment assignment) async {
    try {
      await _service.updateAssignment(assignment);
    } catch (e, stack) {
      _log.e('Erreur updateAssignment', error: e, stackTrace: stack);
    }
  }

  Future<void> deleteAssignment(String id) async {
    try {
      await _service.deleteAssignment(id);
    } catch (e, stack) {
      _log.e('Erreur deleteAssignment', error: e, stackTrace: stack);
    }
  }

  Future<void> syncPendingAssignments() async {
    final unsynced = _assignments.where((a) => !a.isSynced).toList();
    if (unsynced.isNotEmpty) {
      await _service.sync(unsynced);
    }
  }

  // ---------- FILTERS ----------
  List<TeacherAssignment> getByTeacher(String teacherId) {
    return _assignments.where((a) => a.teacherId == teacherId).toList();
  }

  List<TeacherAssignment> getByClass(String classId) {
    return _assignments.where((a) => a.classId == classId).toList();
  }

  List<TeacherAssignment> getByAcademicYear(String year) {
    return _assignments.where((a) => a.academicYear == year).toList();
  }

  List<TeacherAssignment> getByTerm(String term) {
    return _assignments.where((a) => a.term == term).toList();
  }

  // ---------- CLEANUP ----------
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
