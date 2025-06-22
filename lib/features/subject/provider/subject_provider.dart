import 'package:flutter/material.dart';
import '../../../core/models/subject_model.dart';
import '../service/subject_service.dart'; // Assure-toi que le chemin est correct

class SubjectProvider extends ChangeNotifier {
  final SubjectService _subjectService = SubjectService();

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  Subject? _subject;
  Subject? get subject => _subject;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Récupère toutes les matières
  Future<void> fetchSubjects() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _subjects = await _subjectService.getAllSubjects();
    } catch (e) {
      _errorMessage = e.toString();
      _subjects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère une matière par ID Firestore
  Future<void> getSubjectById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _subject = await _subjectService.getSubjectById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _subject = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajoute une nouvelle matière
  Future<Subject?> addSubject(Subject subject) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newSubject = await _subjectService.addSubject(subject);
      if (newSubject != null) {
        _subjects.add(newSubject);
        notifyListeners();
      }
      return newSubject;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Met à jour une matière existante
  Future<void> updateSubject(Subject subject) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _subjectService.updateSubject(subject);
      final index = _subjects.indexWhere((s) => s.id == subject.id);
      if (index != -1) {
        _subjects[index] = subject;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Supprime une matière
  Future<void> deleteSubject(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _subjectService.deleteSubject(id);
      _subjects.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}