import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/models/lesson_model.dart';
import '../service/lesson_service.dart';

class LessonProvider extends ChangeNotifier {
  late LessonService _service;
  final Logger _log = Logger();

  final List<Lesson> _lessons = [];
  bool _isLoading = false;
  String? _error;
  bool _ready = false;
  StreamSubscription? _sub;

  List<Lesson> get lessons => List.unmodifiable(_lessons);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get ready => _ready;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _service = LessonService(schoolId: schoolId);
    await _getOnce();
    _listenToLessons();
  }

  Future<void> _getOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await _service.getAll();
      _lessons
        ..clear()
        ..addAll(data);

      _ready = true;
    } catch (e, stack) {
      _error = e.toString();
      _log.e('LessonProvider init error', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToLessons() {
    _sub?.cancel();
    _sub = _service.ref.snapshots().listen(
      (snapshot) {
        _lessons
          ..clear()
          ..addAll(snapshot.docs.map((doc) => Lesson.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id)));

        _error = null;
        notifyListeners();
      },
      onError: (e, stack) {
        _error = e.toString();
        _log.e('LessonProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      },
    );
  }

  // ---------- CRUD ----------
  Future<void> addLesson(Lesson lesson) async {
    try {
      await _service.addLesson(lesson);
    } catch (e, stack) {
      _log.e('Erreur addLesson', error: e, stackTrace: stack);
    }
  }

  Future<void> updateLesson(Lesson lesson) async {
    try {
      await _service.updateLesson(lesson);
    } catch (e, stack) {
      _log.e('Erreur updateLesson', error: e, stackTrace: stack);
    }
  }

  Future<void> deleteLesson(String id) async {
    try {
      await _service.deleteLesson(id);
    } catch (e, stack) {
      _log.e('Erreur deleteLesson', error: e, stackTrace: stack);
    }
  }

  Future<void> syncPendingLessons() async {
    final unsynced = _lessons.where((e) => !e.isSynced).toList();
    if (unsynced.isNotEmpty) {
      await _service.sync(unsynced);
    }
  }

  // ---------- CLEANUP ----------
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
