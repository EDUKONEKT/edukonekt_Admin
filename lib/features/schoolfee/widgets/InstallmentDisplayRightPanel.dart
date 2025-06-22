import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../provider/ValidatedInstallmentGridsProvider.dart';
import '../provider/installment_grid_provider.dart';

class InstallmentDisplayRightPanel extends StatelessWidget {
  const InstallmentDisplayRightPanel({super.key});

  Future<void> _saveAllInstallmentDefinitions(BuildContext context) async {
   final validatedGridsProvider =
        Provider.of<ValidatedInstallmentGridsProvider>(context, listen: false);
    final gridProvider =
        Provider.of<InstallmentGridProvider>(context, listen: false);

    if (validatedGridsProvider.validatedGrids.isEmpty) return;

    try {
      await gridProvider.addGrids(validatedGridsProvider.validatedGrids);
      validatedGridsProvider.clearAllValidatedGrids();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SchoolFee.installments_saved_success'.tr())),
        );
      }
    } catch (e, stack) {
  debugPrint('Erreur lors de la sauvegarde des grilles: $e');
  debugPrintStack(stackTrace: stack);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SchoolFee.error_saving_installments'.tr())),
    );
  }
}

  }

  void _removeValidatedGrid(BuildContext context, int index) {
    final validatedGridsProvider =
        Provider.of<ValidatedInstallmentGridsProvider>(context, listen: false);
    validatedGridsProvider.removeValidatedGrid(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validatedGridsProvider =
        context.watch<ValidatedInstallmentGridsProvider>();
    final grids = validatedGridsProvider.validatedGrids;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SchoolFee.validated_installments'.tr(),
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 16.0),
          if (grids.isEmpty)
            Text('SchoolFee.no_installments'.tr(),
                style: theme.textTheme.bodyMedium),
          ...List.generate(grids.length, (index) {
            final grid = grids[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(grid.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8.0),
                      ...grid.installments.map((i) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                                '${'SchoolFee.installment'.tr()} ${i.order}: ${i.amount} FCFA — ${i.dueDate.toLocal().toString().split(' ')[0]}'),
                          )),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: theme.colorScheme.error,
                          onPressed: () => _removeValidatedGrid(context, index),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () async {
              await _saveAllInstallmentDefinitions(context);
              Navigator.pop(context, true);
            } ,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('SchoolFee.save_all'.tr()),
          ),
        ],
      ),
    );
  }
}
