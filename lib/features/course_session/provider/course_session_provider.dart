import 'package:flutter/material.dart';
import '../../../core/models/course_session_model.dart';
import '../service/course_session_service.dart'; // Ensure the path is correct

class CourseSessionProvider extends ChangeNotifier {
  final CourseSessionService _courseSessionService = CourseSessionService();

  List<CourseSession> _courseSessions = [];
  List<CourseSession> get courseSessions => _courseSessions;

  CourseSession? _courseSession;
  CourseSession? get courseSession => _courseSession;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all course sessions
  Future<void> fetchCourseSessions() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSessions = await _courseSessionService.getAllCourseSessions();
    } catch (e) {
      _errorMessage = e.toString();
      _courseSessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves a course session by its Firestore ID
  Future<void> getCourseSessionById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSession = await _courseSessionService.getCourseSessionById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _courseSession = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves course sessions for a specific class
  Future<void> fetchCourseSessionsByClass(String classId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSessions = await _courseSessionService.getCourseSessionsByClass(classId);
    } catch (e) {
      _errorMessage = e.toString();
      _courseSessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves course sessions for a specific teacher
  Future<void> fetchCourseSessionsByTeacher(String teacherId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSessions = await _courseSessionService.getCourseSessionsByTeacher(teacherId);
    } catch (e) {
      _errorMessage = e.toString();
      _courseSessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves course sessions for a specific subject
  Future<void> fetchCourseSessionsBySubject(String subjectId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSessions = await _courseSessionService.getCourseSessionsBySubject(subjectId);
    } catch (e) {
      _errorMessage = e.toString();
      _courseSessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves course sessions for a specific day of the week
  Future<void> fetchCourseSessionsByDayOfWeek(int dayOfWeek) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSessions = await _courseSessionService.getCourseSessionsByDayOfWeek(dayOfWeek);
    } catch (e) {
      _errorMessage = e.toString();
      _courseSessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves course sessions for a specific academic year
  Future<void> fetchCourseSessionsByAcademicYear(String academicYear) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _courseSessions = await _courseSessionService.getCourseSessionsByAcademicYear(academicYear);
    } catch (e) {
      _errorMessage = e.toString();
      _courseSessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new course session
  Future<CourseSession?> addCourseSession(CourseSession session) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newCourseSession = await _courseSessionService.addCourseSession(session);
      if (newCourseSession != null) {
        _courseSessions.add(newCourseSession);
        notifyListeners();
      }
      return newCourseSession;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing course session
  Future<void> updateCourseSession(CourseSession session) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _courseSessionService.updateCourseSession(session);
      final index = _courseSessions.indexWhere((s) => s.id == session.id);
      if (index != -1) {
        _courseSessions[index] = session;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes a course session
  Future<void> deleteCourseSession(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _courseSessionService.deleteCourseSession(id);
      _courseSessions.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}