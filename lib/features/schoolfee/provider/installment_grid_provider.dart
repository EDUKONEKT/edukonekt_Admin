import 'package:flutter/material.dart';
import '../../../core/models/installment_grid.dart';
import '../service/installment_grid_service.dart';

class InstallmentGridProvider with ChangeNotifier {
  late InstallmentGridService _service;
  final List<InstallmentGrid> _grids = [];

  List<InstallmentGrid> get grids => List.unmodifiable(_grids);
  bool get hasGrids => _grids.isNotEmpty;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  /// Initialise le provider + charge les grilles existantes s’il y en a
  Future<void> init(String schoolId) async {
    _service = InstallmentGridService(schoolId);
    _isLoading = true;
    Future.microtask(_safeNotifyListeners);
    await loadGrids();
  }

  Future<void> loadGrids() async {
    try {
      final grids = await _service.getAllGrids();
      _grids
        ..clear()
        ..addAll(grids);
    } catch (_) {
      // Erreur silencieuse pour éviter les crashs au démarrage
    }
    _isLoading = false;
    _safeNotifyListeners();
  }

  Future<void> addGrid(InstallmentGrid grid) async {
    await _service.addGridAndLinkToSchool(grid);
    await loadGrids();
  }

  /// 🔄 Ajout de plusieurs grilles validées en une fois (ex: post-validation)
  Future<void> addGrids(List<InstallmentGrid> newGrids) async {
    for (final grid in newGrids) {
      await _service.addGridAndLinkToSchool(grid);
    }
    await loadGrids();
  }

  Future<void> deleteGrid(String id) async {
    await _service.deleteGrid(id);
    _grids.removeWhere((g) => g.id == id);
    _safeNotifyListeners();
  }

  void clear() {
    _grids.clear();
    _safeNotifyListeners();
  }
}
