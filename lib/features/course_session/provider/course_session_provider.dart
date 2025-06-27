import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/models/course_session_model.dart';
import '../service/course_session_service.dart';

class CourseSessionProvider extends ChangeNotifier {
  late CourseSessionService _service;
  final Logger _log = Logger();

  final List<CourseSession> _sessions = [];
  bool _isLoading = false;
  String? _error;
  bool _ready = false;
  StreamSubscription? _sub;

  List<CourseSession> get sessions => List.unmodifiable(_sessions);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get ready => _ready;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _service = CourseSessionService(schoolId: schoolId);
    await _getOnce();
    _listenToSessions();
  }

  Future<void> _getOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await _service.getAll();
      _sessions
        ..clear()
        ..addAll(data);

      _ready = true;
    } catch (e, stack) {
      _error = e.toString();
      _log.e('CourseSessionProvider init error', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToSessions() {
    _sub?.cancel();
    _sub = _service.ref.snapshots().listen(
      (snapshot) {
        _sessions
          ..clear()
          ..addAll(snapshot.docs.map((doc) => CourseSession.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id)));

        _error = null;
        notifyListeners();
      },
      onError: (e, stack) {
        _error = e.toString();
        _log.e('CourseSessionProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      },
    );
  }

  // ---------- CRUD ----------
  Future<void> addCourseSession(CourseSession session) async {
    try {
      await _service.addCourseSession(session);
    } catch (e, stack) {
      _log.e('Erreur addCourseSession', error: e, stackTrace: stack);
    }
  }

  Future<void> updateCourseSession(CourseSession session) async {
    try {
      await _service.updateCourseSession(session);
    } catch (e, stack) {
      _log.e('Erreur updateCourseSession', error: e, stackTrace: stack);
    }
  }

  Future<void> deleteCourseSession(String id) async {
    try {
      await _service.deleteCourseSession(id);
    } catch (e, stack) {
      _log.e('Erreur deleteCourseSession', error: e, stackTrace: stack);
    }
  }

  Future<void> syncPendingSessions() async {
    final unsynced = _sessions.where((s) => !s.isSynced).toList();
    if (unsynced.isNotEmpty) {
      await _service.sync(unsynced);
    }
  }

  // ---------- FILTERS ----------
  List<CourseSession> getByClass(String classId) {
    return _sessions.where((s) => s.classId == classId).toList();
  }
  List<CourseSession> getByClassAndDay(String classId, int dayOfWeek) {
  return _sessions.where((s) => s.classId == classId && s.dayOfWeek == dayOfWeek).toList();
}


  List<CourseSession> getByTeacher(String teacherId) {
    return _sessions.where((s) => s.teacherId == teacherId).toList();
  }

  List<CourseSession> getByDay(int dayOfWeek) {
    return _sessions.where((s) => s.dayOfWeek == dayOfWeek).toList();
  }

  List<CourseSession> getByAcademicYear(String year) {
    return _sessions.where((s) => s.academicYear == year).toList();
  }

  CourseSession? getById(String id) {
    try {
      return _sessions.firstWhere((s) => s.id == id);
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
