import 'package:flutter/material.dart';

import '../../../core/models/installment_grid.dart';
import '../service/installment_grid_service.dart';

class InstallmentGridListDialog extends StatefulWidget {
  final String schoolId;

  const InstallmentGridListDialog({required this.schoolId, super.key});

  @override
  State<InstallmentGridListDialog> createState() => _InstallmentGridListDialogState();
}

class _InstallmentGridListDialogState extends State<InstallmentGridListDialog> {
  late Future<List<InstallmentGrid>> _futureGrids;

  @override
  void initState() {
    super.initState();
    _futureGrids = InstallmentGridService(widget.schoolId).getGridsFromSchoolRef(widget.schoolId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Grilles de paiement"),
      content: SizedBox(
        width: 500,
        child: FutureBuilder<List<InstallmentGrid>>(
          future: _futureGrids,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Aucune grille trouvée.");
            }

            final grids = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: grids.length,
              itemBuilder: (context, index) {
                final grid = grids[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(grid.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                       
                       
                        Text("Montant total : ${grid.amountTot} FCFA"),
                        const SizedBox(height: 8),
                        Column(
                          children: grid.installments.map((installment) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tranche ${installment.order}"),
                                Text("${installment.amount} FCFA"),
                                Text("Échéance : ${installment.dueDate.toLocal().toString().split(' ')[0]}"),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Fermer"),
        ),
      ],
    );
  }
}
