import 'package:flutter/material.dart';
import '../../../core/models/evaluation_model.dart';
import '../service/evaluation_service.dart';

class EvaluationProvider extends ChangeNotifier {
  final EvaluationService _evaluationService = EvaluationService();

  List<Evaluation> _evaluations = [];
  List<Evaluation> get evaluations => _evaluations;

  Evaluation? _evaluation;
  Evaluation? get evaluation => _evaluation;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all evaluations
  Future<void> fetchEvaluations() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _evaluations = await _evaluationService.getAllEvaluations();
    } catch (e) {
      _errorMessage = e.toString();
      _evaluations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves an evaluation by its Firestore ID
  Future<void> getEvaluationById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _evaluation = await _evaluationService.getEvaluationById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _evaluation = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves evaluations for a specific subject
  Future<void> fetchEvaluationsBySubject(String subjectId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _evaluations = await _evaluationService.getEvaluationsBySubject(subjectId);
    } catch (e) {
      _errorMessage = e.toString();
      _evaluations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves evaluations for a specific class
  Future<void> fetchEvaluationsByClass(String classId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _evaluations = await _evaluationService.getEvaluationsByClass(classId);
    } catch (e) {
      _errorMessage = e.toString();
      _evaluations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves evaluations on a specific date
  Future<void> fetchEvaluationsByDate(DateTime date) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _evaluations = await _evaluationService.getEvaluationsByDate(date);
    } catch (e) {
      _errorMessage = e.toString();
      _evaluations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new evaluation
  Future<Evaluation?> addEvaluation(Evaluation evaluation) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newEvaluation = await _evaluationService.addEvaluation(evaluation);
      if (newEvaluation != null) {
        _evaluations.add(newEvaluation);
        notifyListeners();
      }
      return newEvaluation;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing evaluation
  Future<void> updateEvaluation(Evaluation evaluation) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _evaluationService.updateEvaluation(evaluation);
      final index = _evaluations.indexWhere((e) => e.id == evaluation.id);
      if (index != -1) {
        _evaluations[index] = evaluation;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes an evaluation
  Future<void> deleteEvaluation(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _evaluationService.deleteEvaluation(id);
      _evaluations.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}