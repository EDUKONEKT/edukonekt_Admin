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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          _SummaryChip(label: 'Total', value: total.toString()),
          const SizedBox(width: 12),
          _SummaryChip(label: 'Filles', value: girls.toString()),
          const SizedBox(width: 12),
          _SummaryChip(label: 'Garçons', value: boys.toString()),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
