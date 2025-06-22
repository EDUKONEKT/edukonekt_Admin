import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/class_model.dart';
import '../../../core/models/installment_grid.dart';
import '../../schoolfee/service/installment_grid_service.dart';
import '../provider/class_provider.dart'; // Importa il servizio diretto

class AddEditClassForm extends StatefulWidget {
  final Class? classToEdit;
  final String schoolId;

  const AddEditClassForm({super.key, this.classToEdit, required this.schoolId});

  @override
  State<AddEditClassForm> createState() => _AddEditClassFormState();
}

class _AddEditClassFormState extends State<AddEditClassForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLevel;
  String? _selectedSection;
  String? _selectedCycle;
  late TextEditingController _complementController;
  late TextEditingController _teacherIdController;
  String? _selectedInstallmentGridId;

  bool _isEditing = false;
  late Future<List<InstallmentGrid>> _futureGrids;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.classToEdit != null;

    _selectedLevel = widget.classToEdit?.level;
    _selectedSection = widget.classToEdit?.section;
    // Ajustement des cycles : 'premier_cycle' et 'second_cycle'
    _selectedCycle = widget.classToEdit?.cycle;

    if (_isEditing) {
      final classNameParts = widget.classToEdit!.name.split(' ');
      if (classNameParts.length > 2) {
        _complementController = TextEditingController(text: classNameParts.sublist(2).join(' '));
      } else {
        _complementController = TextEditingController();
      }
    } else {
      _complementController = TextEditingController();
    }

    _teacherIdController = TextEditingController(text: widget.classToEdit?.teacherId ?? '');
    _selectedInstallmentGridId = widget.classToEdit?.installmentGridId;

    _futureGrids = InstallmentGridService(widget.schoolId).getGridsFromSchoolRef(widget.schoolId);
  }

  @override
  void dispose() {
    _complementController.dispose();
    _teacherIdController.dispose();
    super.dispose();
  }

  String _generateFullClassName(
      String level, String? section, String? complement) { // section peut être null
    String name = level;
    if (section != null && section.isNotEmpty) {
      name += ' $section';
    }
    if (complement != null && complement.isNotEmpty) {
      name += ' $complement';
    }
    return name;
  }

// ... (ton code existant)

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final String generatedName = _generateFullClassName(
      _selectedLevel!,
      _selectedSection?.trim().isNotEmpty == true ? _selectedSection!.trim() : null,
      _complementController.text.trim().isNotEmpty ? _complementController.text.trim() : null,
    );

    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final now = DateTime.now();

    final newClass = Class(
      id: _isEditing ? widget.classToEdit!.id : '',
      name: generatedName,
      level: _selectedLevel!,
      section: _selectedSection ?? '',
      cycle: _selectedCycle!,
      teacherId: _teacherIdController.text.isEmpty ? '' : _teacherIdController.text,
      installmentGridId: _selectedInstallmentGridId ?? '',
      schoolId: widget.schoolId,
      studentCount: widget.classToEdit?.studentCount ?? 0,
      createdAt: _isEditing ? widget.classToEdit!.createdAt : now,
      updatedAt: now,
    );

    try {
      if (_isEditing) {
        await classProvider.update(newClass);
      } else {
        await classProvider.add(newClass);
      }

      // ***** CORRECTION ICI *****
      // Vérifie si le widget est toujours monté AVANT d'utiliser le context
      if (!mounted) return; // Si le widget n'est plus monté, on arrête ici.

      // Si on arrive ici, le widget est toujours monté, on peut utiliser le context.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Classe modifiée avec succès!' : 'Classe ajoutée avec succès!')),
      );

      // Et aussi ici, avant de pop.
      if (!mounted) return;
      Navigator.pop(context);

    } catch (e) {
      // ***** CORRECTION ICI *****
      // Vérifie si le widget est toujours monté AVANT d'utiliser le context
      if (!mounted) return; // Si le widget n'est plus monté, on arrête ici.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${classProvider.error ?? e.toString()}')),
      );
    }
  }
}

// ... (le reste de ton code)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 24.0,
          left: 24.0,
          right: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEditing ? 'Modifier la Classe' : 'Ajouter une Nouvelle Classe',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: InputDecoration(
                  labelText: 'Niveau *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                hint: const Text('Sélectionnez le niveau'),
                items: ['6e', '5e', '4e', '3e', '2nde', '1ère', 'Tle']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Veuillez sélectionner un niveau' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedSection,
                decoration: InputDecoration(
                  labelText: 'Section (facultatif)', // Libellé mis à jour
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                hint: const Text('Sélectionnez la section'),
                items: ['A', 'B', 'C', '1', '2', '3']
                    .map((section) => DropdownMenuItem(value: section, child: Text(section)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSection = value;
                  });
                },
                // Le validateur est retiré ou modifié pour être facultatif
                validator: (value) => null, // La section n'est plus obligatoire
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _complementController,
                decoration: InputDecoration(
                  labelText: 'Complément de nom (facultatif)',
                  hintText: 'Ex: Allemand, Sport, ...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              // Ajustement des cycles
              DropdownButtonFormField<String>(
                value: _selectedCycle,
                decoration: InputDecoration(
                  labelText: 'Cycle *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                hint: const Text('Sélectionnez le cycle'),
                items: ['premier_cycle', 'second_cycle'] // Les deux cycles possibles
                    .map((cycle) => DropdownMenuItem(value: cycle, child: Text(
                          cycle == 'premier_cycle' ? 'Premier Cycle' : 'Second Cycle'
                        )))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCycle = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Veuillez sélectionner un cycle' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _teacherIdController,
                decoration: InputDecoration(
                  labelText: 'ID Professeur Principal (facultatif)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              FutureBuilder<List<InstallmentGrid>>(
                future: _futureGrids,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Erreur de chargement des grilles: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Aucune grille de versement disponible.',
                          style: TextStyle(color: Colors.orange, fontSize: 14)),
                    );
                  }

                  final grids = snapshot.data!;

                  if (_selectedInstallmentGridId != null &&
                      !grids.any((grid) => grid.id == _selectedInstallmentGridId)) {
                    _selectedInstallmentGridId = null;
                  }

                  if (!_isEditing && _selectedInstallmentGridId == null && grids.isNotEmpty) {
                    _selectedInstallmentGridId = grids.first.id;
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedInstallmentGridId,
                    decoration: InputDecoration(
                      labelText: 'Grille de Versement *',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    hint: const Text('Sélectionnez une grille de versement'),
                    items: grids.map((grid) {
                      return DropdownMenuItem(
                        value: grid.id,
                        child: Text('${grid.name} (${grid.amountTot.toStringAsFixed(2)} FCFA)'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedInstallmentGridId = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Veuillez sélectionner une grille de versement' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(_isEditing ? 'Enregistrer les modifications' : 'Ajouter la Classe'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}