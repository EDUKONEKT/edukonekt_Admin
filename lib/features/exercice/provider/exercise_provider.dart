import 'package:flutter/material.dart';

import '../../../core/models/exercise_model.dart';
import '../service/exercise_service.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();

  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  Exercise? _exercise;
  Exercise? get exercise => _exercise;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all exercises
  Future<void> fetchExercises() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _exercises = await _exerciseService.getAllExercises();
    } catch (e) {
      _errorMessage = e.toString();
      _exercises = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves an exercise by its Firestore ID
  Future<void> getExerciseById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _exercise = await _exerciseService.getExerciseById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _exercise = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves exercises for a specific subject
  Future<void> fetchExercisesBySubject(String subjectId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _exercises = await _exerciseService.getExercisesBySubject(subjectId);
    } catch (e) {
      _errorMessage = e.toString();
      _exercises = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves exercises for a specific class
  Future<void> fetchExercisesByClass(String classId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _exercises = await _exerciseService.getExercisesByClass(classId);
    } catch (e) {
      _errorMessage = e.toString();
      _exercises = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves exercises due on a specific date
  Future<void> fetchExercisesByDueDate(DateTime dueDate) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _exercises = await _exerciseService.getExercisesByDueDate(dueDate);
    } catch (e) {
      _errorMessage = e.toString();
      _exercises = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new exercise
  Future<Exercise?> addExercise(Exercise exercise) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newExercise = await _exerciseService.addExercise(exercise);
      if (newExercise != null) {
        _exercises.add(newExercise);
        notifyListeners();
      }
      return newExercise;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing exercise
  Future<void> updateExercise(Exercise exercise) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _exerciseService.updateExercise(exercise);
      final index = _exercises.indexWhere((e) => e.id == exercise.id);
      if (index != -1) {
        _exercises[index] = exercise;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes an exercise
  Future<void> deleteExercise(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _exerciseService.deleteExercise(id);
      _exercises.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}