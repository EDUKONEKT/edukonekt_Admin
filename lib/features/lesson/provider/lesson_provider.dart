import 'package:flutter/material.dart';

import '../../../core/models/lesson_model.dart';
import '../service/lesson_service.dart';


class LessonProvider extends ChangeNotifier {
  final LessonService _lessonService = LessonService();

  List<Lesson> _lessons = [];
  List<Lesson> get lessons => _lessons;

  Lesson? _lesson;
  Lesson? get lesson => _lesson;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all lessons
  Future<void> fetchLessons() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _lessons = await _lessonService.getAllLessons();
    } catch (e) {
      _errorMessage = e.toString();
      _lessons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves a lesson by its Firestore ID
  Future<void> getLessonById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _lesson = await _lessonService.getLessonById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _lesson = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves lessons by subjectId
  Future<void> fetchLessonsBySubject(String subjectId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _lessons = await _lessonService.getLessonsBySubject(subjectId);
    } catch (e) {
      _errorMessage = e.toString();
      _lessons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves lessons by classId
  Future<void> fetchLessonsByClass(String classId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _lessons = await _lessonService.getLessonsByClass(classId);
    } catch (e) {
      _errorMessage = e.toString();
      _lessons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves lessons by teacherId
  Future<void> fetchLessonsByTeacher(String teacherId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _lessons = await _lessonService.getLessonsByTeacher(teacherId);
    } catch (e) {
      _errorMessage = e.toString();
      _lessons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves lessons by date
  Future<void> fetchLessonsByDate(DateTime date) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _lessons = await _lessonService.getLessonsByDate(date);
    } catch (e) {
      _errorMessage = e.toString();
      _lessons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new lesson
  Future<Lesson?> addLesson(Lesson lesson) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newLesson = await _lessonService.addLesson(lesson);
      if (newLesson != null) {
        _lessons.add(newLesson);
        notifyListeners();
      }
      return newLesson;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing lesson
  Future<void> updateLesson(Lesson lesson) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _lessonService.updateLesson(lesson);
      final index = _lessons.indexWhere((l) => l.id == lesson.id);
      if (index != -1) {
        _lessons[index] = lesson;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes a lesson
  Future<void> deleteLesson(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _lessonService.deleteLesson(id);
      _lessons.removeWhere((l) => l.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}