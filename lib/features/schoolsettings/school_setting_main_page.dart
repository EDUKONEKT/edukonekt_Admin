// 📄 school_setting_main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'school_setting_form_page.dart.dart';
import 'school_setting_provider.dart';


class SchoolSettingMainPage extends StatelessWidget {
  const SchoolSettingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchoolSettingProvider>();
    final setting = provider.setting;
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
        title: const Text("Paramètres horaires"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Configurer",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SchoolSettingFormPage(),
                ),
              );
              if (context.mounted) {
                await provider.getSettingOnce();
              }
            },
          )
        ],
      ),
      body: setting == null
          ? const Center(child: Text("Aucune configuration trouvée."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 7,
              itemBuilder: (_, index) {
                final day = index + 1;
                final daySetting = setting.dailySettings[day];

                if (daySetting == null) {
                  return ListTile(title: Text(days[day]!));
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("📅 ${days[day]}", style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 12),
                            Text(daySetting.isWorkingDay ? "[✅] Ouvré" : "[❌] Non ouvré"),
                          ],
                        ),
                        if (daySetting.isWorkingDay) ...[
                          const SizedBox(height: 8),
                          Text("🕒 Début : ${daySetting.startHour!.format(context)}  🕓 Fin : ${daySetting.endHour!.format(context)}"),
                          const SizedBox(height: 4),
                          if (daySetting.breaks.isNotEmpty) ...[
                            const Text("⏸ Pauses :"),
                            ...daySetting.breaks.map((b) => Text("- ${b.startTime.format(context)} → ${b.endTime.format(context)}")),
                          ]
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
