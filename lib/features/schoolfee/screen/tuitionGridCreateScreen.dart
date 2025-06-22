import 'package:edukonekt_admin/features/schoolfee/widgets/InstallmentDisplayRightPanel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/installment_grid_provider.dart';
import '../widgets/InstallmentInputLeftPanel.dart';


class TuitionGridCreateScreen extends StatefulWidget {
  final String schoolId;
  const TuitionGridCreateScreen({super.key, required this.schoolId});

  @override
  State<TuitionGridCreateScreen> createState() => _TuitionGridCreateScreenState();
}

class _TuitionGridCreateScreenState extends State<TuitionGridCreateScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<InstallmentGridProvider>(context, listen: false).init(widget.schoolId);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer une grille')),
      body: Row(
        children: const [
          Expanded(flex: 2, child: InstallmentInputLeftPanel()),
          SizedBox(width: 16),
          Expanded(flex: 1, child: InstallmentDisplayRightPanel()),
        ],
      ),
    );
  }
}
