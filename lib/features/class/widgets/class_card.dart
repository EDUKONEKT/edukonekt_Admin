import 'package:easy_localization/easy_localization.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const double size = 150.0;

    return SizedBox(
      width: size,
      height: size,
      child: Card(
        color: theme.cardColor,
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
                  // Initiale de la classe
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: colorScheme.primary.withOpacity(0.15),
                    child: Text(
                      classe.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    classe.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${classe.studentCount} ${'students'.tr()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 18, color: colorScheme.primary),
                        onPressed: onEdit,
                        tooltip: 'edit'.tr(),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 18, color: theme.colorScheme.error),
                        onPressed: onDelete,
                        tooltip: 'Delete'.tr(),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const double size = 150.0;

    return SizedBox(
      width: size,
      height: size,
      child: Card(
        color: theme.cardColor,
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
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajouter'.tr(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
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
