import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StudentSummaryBar extends StatelessWidget {
  const StudentSummaryBar({
    super.key,
    required this.total,
    required this.girls,
    required this.boys,
  });

  final int total;
  final int girls;
  final int boys;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SummaryChip(
            icon: Icons.group,
            label: 'Total'.tr(),
            value: total,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.girl,
            label: 'Girls'.tr(),
            value: girls,
            color: Colors.pinkAccent,
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.boy,
            label: 'Boys'.tr(),
            value: boys,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      shape: StadiumBorder(
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        '$label: $value',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
