import 'package:flutter/material.dart';
import '../../../core/models/student_model.dart';

class ModernStudentCard extends StatelessWidget {
  final Student student;
  final String className;
  final VoidCallback onTap;

  const ModernStudentCard({
    super.key,
    required this.student,
    required this.className,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGirl = student.gender.toLowerCase() == 'f';

    final backgroundColor = isDark
        ? const Color(0xFF2D2D2D) // Gris foncé
        : const Color(0xFFE3F2FD); // Bleu très clair (light)

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ---------------- Avatar ----------------
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  isGirl
                      ? 'lib/image/avatar_ecoliere.png'
                      : 'lib/image/avatar_ecolier.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // ---------------- Name + Class ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.secondaryContainer
                            : theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school,
                              size: 16,
                              color: isDark
                                  ? theme.colorScheme.onSecondaryContainer
                                  : theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            className,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isDark
                                  ? theme.colorScheme.onSecondaryContainer
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- Chevron ----------------
              Icon(Icons.chevron_right,
                  color: theme.iconTheme.color?.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
