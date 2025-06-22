import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../class/provider/class_provider.dart';

class StudentFilterDrawer extends StatelessWidget {
  const StudentFilterDrawer({
    super.key,
    required this.selectedCycle,
    required this.selectedClassId,
    required this.onCycleChanged,
    required this.onClassChanged,
  });

  final String? selectedCycle;
  final String? selectedClassId;
  final ValueChanged<String?> onCycleChanged;
  final ValueChanged<String?> onClassChanged;

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();

    return Container(
      width: 260,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        children: [
          Text('Cycle', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioListTile<String?>(
            title: const Text('Tous'),
            value: null,
            groupValue: selectedCycle,
            onChanged: onCycleChanged,
          ),
          RadioListTile<String>(
            title: const Text('1er cycle'),
            value: 'cycle1',
            groupValue: selectedCycle,
            onChanged: onCycleChanged,
          ),
          RadioListTile<String>(
            title: const Text('2e cycle'),
            value: 'cycle2',
            groupValue: selectedCycle,
            onChanged: onCycleChanged,
          ),
          const Divider(height: 32),
          Text('Classe', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...classProvider.classes.map(
            (c) => RadioListTile<String?>(
              title: Text(c.name),
              value: c.id,
              groupValue: selectedClassId,
              onChanged: onClassChanged,
            ),
          ),
        ],
      ),
    );
  }
}
