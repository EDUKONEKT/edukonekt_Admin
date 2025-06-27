import 'package:flutter/material.dart';

class TeacherFilterDrawer extends StatelessWidget {
  const TeacherFilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceVariant,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Filtres', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Genre'),
          // ... CheckboxListTiles pour homme/femme
          SizedBox(height: 16),
          Text('Matières'),
          // ... Chips ou liste matières
        ],
      ),
    );
  }
}