// 📄 school_setting_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/break_slot_model.dart';
import '../../core/models/daysetting.dart';
import '../../core/models/school_setting_model.dart';
import 'school_setting_provider.dart';


class SchoolSettingFormPage extends StatefulWidget {
  const SchoolSettingFormPage({super.key});

  @override
  State<SchoolSettingFormPage> createState() => _SchoolSettingFormPageState();
}

class _SchoolSettingFormPageState extends State<SchoolSettingFormPage> {
  late Map<int, DaySetting> _localDays;

  @override
  void initState() {
    super.initState();
    final setting = context.read<SchoolSettingProvider>().setting;
    _localDays = setting?.dailySettings ?? {
      for (int i = 1; i <= 7; i++) i: DaySetting.empty(),
    };
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur de validation"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  bool _validateConfig() {
    for (var entry in _localDays.entries) {
      final day = entry.key;
      final setting = entry.value;
      if (!setting.isWorkingDay) continue;

      if (setting.startHour == null || setting.endHour == null) {
        _showErrorDialog("Le jour $day doit avoir une heure de début et de fin.");
        return false;
      }

      final startMinutes = setting.startHour!.hour * 60 + setting.startHour!.minute;
      final endMinutes = setting.endHour!.hour * 60 + setting.endHour!.minute;

      if (startMinutes >= endMinutes) {
        _showErrorDialog("Le jour $day a une heure de début supérieure ou égale à l'heure de fin.");
        return false;
      }

      for (var b in setting.breaks) {
        final bStart = b.startTime.hour * 60 + b.startTime.minute;
        final bEnd = b.endTime.hour * 60 + b.endTime.minute;

        if (bStart >= bEnd) {
          _showErrorDialog("Une pause du jour $day a un début >= fin.");
          return false;
        }
        if (bStart < startMinutes || bEnd > endMinutes) {
          _showErrorDialog("Une pause du jour $day dépasse les horaires de la journée.");
          return false;
        }
      }

      final sorted = List<BreakSlot>.from(setting.breaks)
        ..sort((a, b) => (a.startTime.hour * 60 + a.startTime.minute)
            .compareTo(b.startTime.hour * 60 + b.startTime.minute));

      for (int i = 0; i < sorted.length - 1; i++) {
        final a = sorted[i];
        final b = sorted[i + 1];
        final aEnd = a.endTime.hour * 60 + a.endTime.minute;
        final bStart = b.startTime.hour * 60 + b.startTime.minute;
        if (aEnd > bStart) {
          _showErrorDialog("Deux pauses se chevauchent le jour $day.");
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchoolSettingProvider>();
    final days = {
      1: 'Lundi',
      2: 'Mardi',
      3: 'Mercredi',
      4: 'Jeudi',
      5: 'Vendredi',
      6: 'Samedi',
      7: 'Dimanche',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurer les horaires"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Enregistrer",
            onPressed: () async {
  if (!_validateConfig()) return;

  final updated = SchoolSetting(
    id: provider.setting?.id ?? '',
    schoolId: provider.service.schoolId,
    isSynced: false,
    createdAt: provider.setting?.createdAt ?? DateTime.now(),
    updatedAt: DateTime.now(),
    dailySettings: _localDays,
  );

  await provider.updateSetting(updated);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Paramètres enregistrés (hors ligne si besoin)")),
    );
    Navigator.pop(context);
  }
}
,
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (_, index) {
          final day = index + 1;
          return _DaySettingCardForm(
            day: day,
            dayLabel: days[day]!,
            setting: _localDays[day]!,
            onChanged: (updated) => setState(() => _localDays[day] = updated),
          );
        },
      ),
    );
  }
}

// Le widget _DaySettingCardForm reste inchangé

class _DaySettingCardForm extends StatelessWidget {
  final int day;
  final String dayLabel;
  final DaySetting setting;
  final void Function(DaySetting) onChanged;

  const _DaySettingCardForm({
    required this.day,
    required this.dayLabel,
    required this.setting,
    required this.onChanged,
  });

  Future<void> _pickTime(BuildContext context, TimeOfDay? initial, void Function(TimeOfDay) onPicked) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initial ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (time != null) onPicked(time);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('📅 $dayLabel', style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: setting.isWorkingDay,
                  onChanged: (v) => onChanged(setting.copyWith(isWorkingDay: v)),
                ),
              ],
            ),
            if (setting.isWorkingDay) ...[
              Row(
                children: [
                  const Text("🕒 Début : "),
                  TextButton(
                    onPressed: () => _pickTime(context, setting.startHour, (t) => onChanged(setting.copyWith(startHour: t))),
                    child: Text(setting.startHour?.format(context) ?? '—'),
                  ),
                  const SizedBox(width: 24),
                  const Text("🕓 Fin : "),
                  TextButton(
                    onPressed: () => _pickTime(context, setting.endHour, (t) => onChanged(setting.copyWith(endHour: t))),
                    child: Text(setting.endHour?.format(context) ?? '—'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text("⏸ Pauses :"),
              ...setting.breaks.asMap().entries.map((e) {
                final i = e.key;
                final b = e.value;
                return Row(
                  children: [
                    Text("${b.startTime.format(context)} → ${b.endTime.format(context)}"),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        final updated = List<BreakSlot>.from(setting.breaks)..removeAt(i);
                        onChanged(setting.copyWith(breaks: updated));
                      },
                    ),
                  ],
                );
              }),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Ajouter une pause"),
                onPressed: () async {
                  final start = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
                  if (start == null) return;
                  final end = await showTimePicker(context: context, initialTime: TimeOfDay(hour: start.hour + 1, minute: 0));
                  if (end == null) return;
                  final updated = List<BreakSlot>.from(setting.breaks)
                    ..add(BreakSlot(startTime: start, endTime: end));
                  onChanged(setting.copyWith(breaks: updated));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
