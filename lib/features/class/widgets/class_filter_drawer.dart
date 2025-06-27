import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// --------------------------------------------------
/// 1. Drawer latéral de filtres pour les classes
/// --------------------------------------------------
class ClassFilterDrawer extends StatelessWidget {
  final String? selectedCycle;
  final String? selectedLevel;
  final String searchQuery;
  final ValueChanged<String?> onCycleChanged;
  final ValueChanged<String?> onLevelChanged;
  final ValueChanged<String> onSearchChanged;

  const ClassFilterDrawer({
    super.key,
    this.selectedCycle,
    this.selectedLevel,
    required this.searchQuery,
    required this.onCycleChanged,
    required this.onLevelChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 250,
      color: theme.cardColor,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 🔍  Recherche
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TextField(
              controller: TextEditingController(text: searchQuery),
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Search for a class'.tr(),
                hintText: 'ex:form 1 A'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor ??
                    colorScheme.surfaceVariant.withOpacity(0.3),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24.0),

          // 🏫  Cycle
          Text(
            'By Cycle'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          _radioTile(context, '', 'All'.tr(), selectedCycle, onCycleChanged),
          _radioTile(context, 'premier_cycle', 'premier_cycle'.tr(), selectedCycle, onCycleChanged),
          _radioTile(context, 'second_cycle', 'second_cycle'.tr(), selectedCycle, onCycleChanged),

          const SizedBox(height: 24.0),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24.0),

          // 🎚️  Niveau
          Text(
            'By Level'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          _radioTile(context, '', 'All'.tr(), selectedLevel, onLevelChanged),
          ...['6e', '5e', '4e', '3e', '2nde', '1ère', 'Tle']
              .map((level) => _radioTile(context, level.tr(), level.tr(), selectedLevel, onLevelChanged)),
        ],
      ),
    );
  }

  Widget _radioTile(
    BuildContext context,
    String value,
    String label,
    String? group,
    ValueChanged<String?> onChanged,
  ) {
    final theme = Theme.of(context);
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: group,
      onChanged: onChanged,
      activeColor: theme.colorScheme.secondary,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
