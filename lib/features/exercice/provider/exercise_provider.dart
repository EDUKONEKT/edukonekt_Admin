import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/models/exercise_model.dart';
import '../service/exercise_service.dart';

class ExerciseProvider extends ChangeNotifier {
  late ExerciseService _service;
  final Logger _log = Logger();

  final List<Exercise> _exercises = [];
  bool _isLoading = false;
  String? _error;
  bool _ready = false;
  StreamSubscription? _sub;

  List<Exercise> get exercises => List.unmodifiable(_exercises);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get ready => _ready;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _service = ExerciseService(schoolId: schoolId);
    await _getOnce();
    _listenToExercises();
  }

  Future<void> _getOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await _service.getAll();
      _exercises
        ..clear()
        ..addAll(data);

      _ready = true;
    } catch (e, stack) {
      _error = e.toString();
      _log.e('ExerciseProvider init error', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToExercises() {
    _sub?.cancel();
    _sub = _service.ref.snapshots().listen(
      (snapshot) {
        _exercises
          ..clear()
          ..addAll(snapshot.docs.map((doc) => Exercise.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id)));

        _error = null;
        notifyListeners();
      },
      onError: (e, stack) {
        _error = e.toString();
        _log.e('ExerciseProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      },
    );
  }

  // ---------- CRUD ----------
  Future<void> addExercise(Exercise exercise) async {
    try {
      await _service.addExercise(exercise);
    } catch (e, stack) {
      _log.e('Erreur addExercise', error: e, stackTrace: stack);
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _service.updateExercise(exercise);
    } catch (e, stack) {
      _log.e('Erreur updateExercise', error: e, stackTrace: stack);
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _service.deleteExercise(id);
    } catch (e, stack) {
      _log.e('Erreur deleteExercise', error: e, stackTrace: stack);
    }
  }

  Future<void> syncPendingExercises() async {
    final unsynced = _exercises.where((e) => !e.isSynced).toList();
    if (unsynced.isNotEmpty) {
      await _service.sync(unsynced);
    }
  }

  // ---------- FILTERS ----------
  List<Exercise> getByClass(String classId) {
    return _exercises.where((e) => e.classId == classId).toList();
  }

  List<Exercise> getBySubject(String subjectId) {
    return _exercises.where((e) => e.subjectId == subjectId).toList();
  }

  List<Exercise> getByDueDate(DateTime date) {
    return _exercises.where((e) =>
      e.dueDate.year == date.year &&
      e.dueDate.month == date.month &&
      e.dueDate.day == date.day
    ).toList();
  }

  Exercise? getById(String id) {
    try {
      return _exercises.firstWhere((e) => e.id == id);
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
