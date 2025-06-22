import 'package:flutter/material.dart';

class ClassFilterDrawer extends StatelessWidget {
  final String? selectedCycle;
  final String? selectedLevel;
  final String searchQuery;
  final ValueChanged<String?> onCycleChanged;
  final ValueChanged<String?> onLevelChanged;
  final ValueChanged<String> onSearchChanged;

  const ClassFilterDrawer({
    super.key,
    this.selectedCycle,
    this.selectedLevel,
    required this.searchQuery,
    required this.onCycleChanged,
    required this.onLevelChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Larghezza fissa per i filtri laterali
      color: Theme.of(context).cardColor, // Colore di sfondo dei filtri
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Campo di ricerca
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TextField(
              controller: TextEditingController(text: searchQuery),
              decoration: InputDecoration(
                labelText: 'Rechercher une classe',
                hintText: 'Ex: 6e A',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // Nessun bordo diretto
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey.shade200,
              ),
              onChanged: onSearchChanged,
            ),
          ),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24.0),

          // Filtri per ciclo
          Text(
            'Par Cycle',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          RadioListTile<String>(
            title: const Text('Tous'),
            value: '',
            groupValue: selectedCycle,
            onChanged: onCycleChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          RadioListTile<String>(
            title: const Text('Premier Cycle'),
            value: 'premier_cycle',
            groupValue: selectedCycle,
            onChanged: onCycleChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          RadioListTile<String>(
            title: const Text('Second Cycle'),
            value: 'second_cycle', // Puoi usare "cycle2" o un valore più specifico
            groupValue: selectedCycle,
            onChanged: onCycleChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 24.0),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24.0),

          // Filtri per livello
          Text(
            'Par Niveau',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          RadioListTile<String>(
            title: const Text('Tous'),
            value: '',
            groupValue: selectedLevel,
            onChanged: onLevelChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          // Esempio di alcuni livelli, puoi estenderli
          ...['6e', '5e', '4e', '3e', '2nde', '1ère', 'Tle'].map((level) =>
              RadioListTile<String>(
                title: Text(level),
                value: level,
                groupValue: selectedLevel,
                onChanged: onLevelChanged,
                activeColor: Theme.of(context).colorScheme.secondary,
              )),
        ],
      ),
    );
  }
}