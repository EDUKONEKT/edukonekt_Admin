import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../core/models/subject_model.dart';
import '../service/subject_service.dart';

final Logger _log = Logger();

class SubjectProvider with ChangeNotifier {
  SubjectProvider();

  late final SubjectService _service;
  late String _schoolId;
  StreamSubscription? _sub;

  final List<Subject> _subjects = [];
  List<Subject> get subjects => List.unmodifiable(_subjects);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isReady = false;
  bool get isReady => _isReady;

  Object? _error;
  Object? get error => _error;

  SubjectService get service => _service;

  // ---------- INIT ----------
  Future<void> init(String schoolId) async {
    _schoolId = schoolId;
    _service = SubjectService();
    await _getOnce();
    _listenToSubjects();
  }

  Future<void> _getOnce() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await _service.getSubjectsOnce(_schoolId);
      _subjects
        ..clear()
        ..addAll(data);

      _isReady = true;
    } catch (e, s) {
      _error = e;
      _log.e('SubjectProvider init error', error: e, stackTrace: s);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToSubjects() {
    _sub?.cancel();
    _sub = _service.watchSubjects(_schoolId).listen(
      (newList) {
        _subjects
          ..clear()
          ..addAll(newList);
        _error = null;
        notifyListeners();
      },
      onError: (e, s) {
        _error = e;
        _log.e('SubjectProvider stream error', error: e, stackTrace: s);
        notifyListeners();
      },
    );
  }

  // ---------- CRUD ----------
  Future<void> addSubject(Subject s) async {
    try {
      await _service.addSubject(_schoolId, s);
    } catch (e, s) {
      _log.e('addSubject error', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateSubject(Subject s) async {
    try {
      await _service.updateSubject(_schoolId, s);
    } catch (e, s) {
      _log.e('updateSubject error', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteSubject(String id) async {
    try {
      await _service.deleteSubject(_schoolId, id);
    } catch (e, s) {
      _log.e('deleteSubject error', error: e, stackTrace: s);
      rethrow;
    }
  }

  Subject? getById(String id) {
  try {
    return _subjects.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}


  // ---------- FILTERS ----------
  Subject? getByName(String name) => _service.getByName(_subjects, name);
  Subject? getByCode(String code) => _service.getByCode(_subjects, code);
  List<Subject> filterByKeyword(String keyword) => _service.filterByKeyword(_subjects, keyword);
  List<Subject> get unsyncedSubjects => _subjects.where((s) => !s.isSynced).toList();

  // ---------- CLEANUP ----------
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
