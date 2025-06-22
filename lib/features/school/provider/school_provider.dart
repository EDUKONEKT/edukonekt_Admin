import 'package:flutter/material.dart';
import '../../../core/models/school.dart';
import '../service/school_service.dart';

class SchoolProvider with ChangeNotifier {
  final SchoolService _service = SchoolService();

  School? _school;
  School? get school => _school;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSchool(String schoolId) async {
    _isLoading = true;
    notifyListeners();

    _school = await _service.getFirstSchool();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createOrUpdateSchool(School school) async {
    _isLoading = true;
    notifyListeners();

    if (school.id.isEmpty) {
      final newId = await _service.createSchool(school);
      _school = School(
        id: newId,
        name: school.name,
        schoolYear: school.schoolYear,
        tariffPlan: school.tariffPlan,
      );
    } else {
      await _service.updateSchool(school);
      _school = school;
    }

    _isLoading = false;
    notifyListeners();
  }
}
