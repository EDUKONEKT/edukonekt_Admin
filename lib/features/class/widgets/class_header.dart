import 'package:flutter/material.dart';

class ClassHeader extends StatelessWidget {
  final int totalClasses;
  final int totalStudents; // Questo sarà da implementare in futuro

  const ClassHeader({
    super.key,
    required this.totalClasses,
    required this.totalStudents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), // Ombra leggera
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.school,
            label: 'Total Classes',
            value: totalClasses.toString(),
            color: theme.colorScheme.primary,
          ),
          _buildStatItem(
            context,
            icon: Icons.groups,
            label: 'Total Élèves',
            value: totalStudents.toString(), // Segnaposto
            color: theme.colorScheme.secondary,
          ),
          // Puoi aggiungere altre statistiche qui
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}