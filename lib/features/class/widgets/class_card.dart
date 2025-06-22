import 'package:flutter/material.dart';

import '../../../core/models/class_model.dart';

class ClassCard extends StatelessWidget {
  final Class classe;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClassCard({
    super.key,
    required this.classe,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final size = 150.0;

    return SizedBox(
      width: size,
      height: size,
      child: Card(
        elevation: 4,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lettre initiale dans un petit cercle
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        classe.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    classe.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${classe.studentCount} élèves',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 18, color: Theme.of(context).colorScheme.primary),
                        onPressed: onEdit,
                        tooltip: 'Modifier',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 18, color: Theme.of(context).colorScheme.error),
                        onPressed: onDelete,
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ClassAddCard extends StatelessWidget {
  final VoidCallback onTap;

  const ClassAddCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = 150.0;

    return SizedBox(
      width: size,
      height: size,
      child: Card(
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajouter',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
