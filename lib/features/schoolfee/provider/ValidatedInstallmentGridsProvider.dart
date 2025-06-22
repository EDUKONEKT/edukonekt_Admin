import 'package:flutter/material.dart';
import '../../../../core/models/installment_grid.dart';

class ValidatedInstallmentGridsProvider with ChangeNotifier {
  final List<InstallmentGrid> _validatedGrids = [];

  List<InstallmentGrid> get validatedGrids => _validatedGrids;

  void addValidatedGrid(InstallmentGrid grid) {
    _validatedGrids.add(grid);
    notifyListeners();
  }

  void removeValidatedGrid(int index) {
    _validatedGrids.removeAt(index);
    notifyListeners();
  }

  void clearAllValidatedGrids() {
    _validatedGrids.clear();
    notifyListeners();
  }
}
