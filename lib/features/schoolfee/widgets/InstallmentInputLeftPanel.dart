import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/models/installment.dart';
import '../../../../core/models/installment_grid.dart';
import '../provider/ValidatedInstallmentGridsProvider.dart';

class InstallmentInputLeftPanel extends StatefulWidget {
  const InstallmentInputLeftPanel({super.key});

  @override
  _InstallmentInputLeftPanelState createState() => _InstallmentInputLeftPanelState();
}

class _InstallmentInputLeftPanelState extends State<InstallmentInputLeftPanel> {
  final TextEditingController _gridNameController = TextEditingController();
  final TextEditingController _numberOfInstallmentsController = TextEditingController();
  int _numberOfInstallments = 0;
  final List<Widget> _installmentInputFields = [];
  List<TextEditingController> _amountControllers = [];
  List<TextEditingController> _dueDateControllers = [];

  void _updateInstallmentFields() {
    setState(() {
      int entered = int.tryParse(_numberOfInstallmentsController.text) ?? 0;
      if (entered < 1) {
      entered = 0;
      } else if (entered > 4) {
      entered = 4;
      }
_numberOfInstallments = entered;

      _installmentInputFields.clear();
      _amountControllers = List.generate(_numberOfInstallments, (_) => TextEditingController());
      _dueDateControllers = List.generate(_numberOfInstallments, (_) => TextEditingController());

      for (int i = 0; i < _numberOfInstallments; i++) {
        _installmentInputFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountControllers[i],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'SchoolFee.amount'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _dueDateControllers[i],
                    decoration: InputDecoration(
                      labelText: 'SchoolFee.due_date'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2030),
                      );
                      if (selectedDate != null) {
                        _dueDateControllers[i].text = selectedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  void _validateAndAddToRightPanel(BuildContext context) {
    final validatedGridsProvider = Provider.of<ValidatedInstallmentGridsProvider>(context, listen: false);
    String gridLabel = _gridNameController.text.trim();
    List<Installment> installments = [];
    bool isValid = true;
    double amounttot=0;
    for (int i = 0; i < _numberOfInstallments; i++) {
      double? amount = double.tryParse(_amountControllers[i].text);
      DateTime? dueDate = DateTime.tryParse(_dueDateControllers[i].text);

      if (amount == null || dueDate == null) {
        isValid = false;
        break;
      }
      amounttot = amounttot+amount;
      installments.add(Installment(order: i + 1, amount: amount, dueDate: dueDate));
    }

    if (isValid && gridLabel.isNotEmpty && installments.isNotEmpty) {
      final grid = InstallmentGrid(
        id: const Uuid().v4(),
        name: gridLabel,
        classId: 'default',
        amountTot: amounttot, // à remplacer selon ta logique réelle
        installments: installments,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      validatedGridsProvider.addValidatedGrid(grid);

      _gridNameController.clear();
      _numberOfInstallmentsController.clear();
      setState(() {
        _numberOfInstallments = 0;
        _installmentInputFields.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SchoolFee.validation_error_installments'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _gridNameController,
            decoration: InputDecoration(
              labelText: 'SchoolFee.grid_name'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _numberOfInstallmentsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'SchoolFee.number_of_installments'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            onChanged: (_) => _updateInstallmentFields(),
          ),
          const SizedBox(height: 16.0),
          ..._installmentInputFields,
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () => _validateAndAddToRightPanel(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('SchoolFee.validate'.tr()),
          ),
        ],
      ),
    );
  }
}
