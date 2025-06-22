import 'package:flutter/material.dart';
import '../../../core/models/teacher_model.dart';
import '../service/teacher_service.dart';


class TeacherProvider extends ChangeNotifier {
  final TeacherService _service = TeacherService();

  List<Teacher> _teachers = [];
  List<Teacher> get teachers => _teachers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAllTeachers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _teachers = await _service.getAllTeachers();
    } catch (e) {
      debugPrint('Erreur lors du chargement des enseignants: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Teacher?> getTeacherById(String id) async {
    try {
      return await _service.getTeacherById(id);
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'enseignant: $e');
      return null;
    }
  }
  

  Future<List<Teacher>> getTeachersBySubject(String subjectId) async {
    try {
      return await _service.getTeachersBySubject(subjectId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des enseignants par matière: $e');
      return [];
    }
  }
}
