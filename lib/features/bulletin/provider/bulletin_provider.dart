import 'package:flutter/material.dart';

import '../../../core/models/bulletin_model.dart';
import '../service/bulletin_service.dart';

class BulletinProvider extends ChangeNotifier {
  final BulletinService _bulletinService = BulletinService();

  List<Bulletin> _bulletins = [];
  List<Bulletin> get bulletins => _bulletins;

  Bulletin? _bulletin;
  Bulletin? get bulletin => _bulletin;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all bulletins
  Future<void> fetchBulletins() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _bulletins = await _bulletinService.getAllBulletins();
    } catch (e) {
      _errorMessage = e.toString();
      _bulletins = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves a bulletin by its Firestore ID
  Future<void> getBulletinById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _bulletin = await _bulletinService.getBulletinById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _bulletin = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves bulletins for a specific student
  Future<void> fetchBulletinsByStudent(String studentId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _bulletins = await _bulletinService.getBulletinsByStudent(studentId);
    } catch (e) {
      _errorMessage = e.toString();
      _bulletins = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves bulletins for a specific class
  Future<void> fetchBulletinsByClass(String classId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _bulletins = await _bulletinService.getBulletinsByClass(classId);
    } catch (e) {
      _errorMessage = e.toString();
      _bulletins = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves bulletins for a specific academic year
  Future<void> fetchBulletinsByAcademicYear(String academicYear) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _bulletins = await _bulletinService.getBulletinsByAcademicYear(academicYear);
    } catch (e) {
      _errorMessage = e.toString();
      _bulletins = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves bulletins for a specific term
  Future<void> fetchBulletinsByTerm(String term) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _bulletins = await _bulletinService.getBulletinsByTerm(term);
    } catch (e) {
      _errorMessage = e.toString();
      _bulletins = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new bulletin
  Future<Bulletin?> addBulletin(Bulletin bulletin) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newBulletin = await _bulletinService.addBulletin(bulletin);
      if (newBulletin != null) {
        _bulletins.add(newBulletin);
        notifyListeners();
      }
      return newBulletin;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing bulletin
  Future<void> updateBulletin(Bulletin bulletin) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _bulletinService.updateBulletin(bulletin);
      final index = _bulletins.indexWhere((b) => b.id == bulletin.id);
      if (index != -1) {
        _bulletins[index] = bulletin;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes a bulletin
  Future<void> deleteBulletin(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _bulletinService.deleteBulletin(id);
      _bulletins.removeWhere((b) => b.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}