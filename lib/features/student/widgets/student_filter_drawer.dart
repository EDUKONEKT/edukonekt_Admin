import 'package:easy_localization/easy_localization.dart';
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
    final theme = Theme.of(context);

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(2, 0),
            color: theme.shadowColor.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------- Titre du Drawer ---------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.filter_alt_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Filters'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),

            // --------------------- Contenu Scrollable ---------------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, 'Cycle'.tr()),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _chip(context, label: 'All'.tr(), value: null, group: selectedCycle, onSelected: onCycleChanged),
                        _chip(context, label: '1st cycle'.tr(), value: 'premier cycle', group: selectedCycle, onSelected: onCycleChanged),
                        _chip(context, label: '2nd cycle'.tr(), value: 'second cycle', group: selectedCycle, onSelected: onCycleChanged),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle(context, 'Class'.tr()),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final c in classProvider.classes)
                          _chip(context,
                              label: c.name,
                              value: c.id,
                              group: selectedClassId,
                              onSelected: onClassChanged),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --------------------- Bouton Réinitialiser ---------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide(color: theme.colorScheme.primary),
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const Icon(Icons.refresh),
                label: Text('Réinitialiser'.tr()),
                onPressed: () {
                  onCycleChanged(null);
                  onClassChanged(null);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- Section Title -------------------
  Widget _sectionTitle(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      );

  // ------------------- Chips avec Thème -------------------
  ChoiceChip _chip(BuildContext context,
      {required String label,
      required String? value,
      required String? group,
      required ValueChanged<String?> onSelected}) {
    final bool selected = group == value;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: selected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
      ),
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceVariant,
      shape: StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
