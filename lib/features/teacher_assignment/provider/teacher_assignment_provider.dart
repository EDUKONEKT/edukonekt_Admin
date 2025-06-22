import 'package:flutter/material.dart';

import '../../../core/models/teacher_assignment_model.dart';
import '../service/teacher_assignment_service.dart';


class TeacherAssignmentProvider extends ChangeNotifier {
  final TeacherAssignmentService _teacherAssignmentService = TeacherAssignmentService();

  List<TeacherAssignment> _teacherAssignments = [];
  List<TeacherAssignment> get teacherAssignments => _teacherAssignments;

  TeacherAssignment? _teacherAssignment;
  TeacherAssignment? get teacherAssignment => _teacherAssignment;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Récupère toutes les assignations d'enseignants
  Future<void> fetchTeacherAssignments() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _teacherAssignments = await _teacherAssignmentService.getAllTeacherAssignments();
    } catch (e) {
      _errorMessage = e.toString();
      _teacherAssignments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère une assignation d'enseignant par ID Firestore
  Future<void> getTeacherAssignmentById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _teacherAssignment = await _teacherAssignmentService.getTeacherAssignmentById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _teacherAssignment = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère les assignations d'enseignant pour un enseignant spécifique
  Future<void> fetchTeacherAssignmentsByTeacher(String teacherId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _teacherAssignments = await _teacherAssignmentService.getTeacherAssignmentsByTeacher(teacherId);
    } catch (e) {
      _errorMessage = e.toString();
      _teacherAssignments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère les assignations d'enseignant pour une matière spécifique
  Future<void> fetchTeacherAssignmentsBySubject(String subjectId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _teacherAssignments = await _teacherAssignmentService.getTeacherAssignmentsBySubject(subjectId);
    } catch (e) {
      _errorMessage = e.toString();
      _teacherAssignments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère les assignations d'enseignant pour une classe spécifique
  Future<void> fetchTeacherAssignmentsByClass(String classId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _teacherAssignments = await _teacherAssignmentService.getTeacherAssignmentsByClass(classId);
    } catch (e) {
      _errorMessage = e.toString();
      _teacherAssignments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajoute une nouvelle assignation d'enseignant
  Future<TeacherAssignment?> addTeacherAssignment(TeacherAssignment assignment) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newAssignment = await _teacherAssignmentService.addTeacherAssignment(assignment);
      if (newAssignment != null) {
        _teacherAssignments.add(newAssignment);
        notifyListeners();
      }
      return newAssignment;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Met à jour une assignation d'enseignant existante
  Future<void> updateTeacherAssignment(TeacherAssignment assignment) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _teacherAssignmentService.updateTeacherAssignment(assignment);
      final index = _teacherAssignments.indexWhere((a) => a.id == assignment.id);
      if (index != -1) {
        _teacherAssignments[index] = assignment;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Supprime une assignation d'enseignant
  Future<void> deleteTeacherAssignment(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _teacherAssignmentService.deleteTeacherAssignment(id);
      _teacherAssignments.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}