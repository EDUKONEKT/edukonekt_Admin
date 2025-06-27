// ---------- OccupiedSlotsView.dart corrigé ----------
import 'package:flutter/material.dart';
import '../../../core/models/course_session_model.dart';
import '../../../core/models/break_slot_model.dart';

class OccupiedSlotsView extends StatelessWidget {
  final List<CourseSession> sessionsOfDay;
  final TimeOfDay schoolStart;
  final TimeOfDay schoolEnd;
  final List<BreakSlot> breaks;

  const OccupiedSlotsView({
    super.key,
    required this.sessionsOfDay,
    required this.schoolStart,
    required this.schoolEnd,
    required this.breaks,
  });

  @override
  Widget build(BuildContext context) {
    final slots = _generateTimeSlots(schoolStart, schoolEnd);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Créneaux horaires :', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isBreak = breaks.any((b) => _isWithinSlot(slot, b.startTime, b.endTime));
            final isOccupied = sessionsOfDay.any((s) => !_isSlotFree(slot, s.startTime, s.endTime));

            Color color;
            if (isBreak) {
              color = Colors.green.withOpacity(0.6);
            } else if (isOccupied) {
              color = Colors.red.withOpacity(0.6);
            } else {
              color = Colors.grey.withOpacity(0.2);
            }

            return Chip(
              label: Text(slot.format(context)),
              backgroundColor: color,
            );
          }).toList(),
        ),
      ],
    );
  }

  List<TimeOfDay> _generateTimeSlots(TimeOfDay start, TimeOfDay end) {
    final slots = <TimeOfDay>[];
    var current = start;
    while (_compareTime(current, end) < 0) {
      slots.add(current);
      final nextMinute = (current.minute + 15) % 60;
      final addHour = (current.minute + 15) ~/ 60;
      current = TimeOfDay(hour: current.hour + addHour, minute: nextMinute);
    }
    return slots;
  }

  bool _isWithinSlot(TimeOfDay slot, TimeOfDay start, TimeOfDay end) {
    final slotMin = slot.hour * 60 + slot.minute;
    final startMin = start.hour * 60 + start.minute;
    final endMin = end.hour * 60 + end.minute;
    return slotMin >= startMin && slotMin <= endMin;
  }

  bool _isSlotFree(TimeOfDay slot, TimeOfDay start, TimeOfDay end) {
    return !_isWithinSlot(slot, start, end);
  }

  int _compareTime(TimeOfDay a, TimeOfDay b) {
    return (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute);
  }
}
