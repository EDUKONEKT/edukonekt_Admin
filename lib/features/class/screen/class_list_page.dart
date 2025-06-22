import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/class_model.dart';
import '../provider/class_provider.dart';
import '../widgets/add_edit_class_form.dart';
import '../widgets/class_card.dart';
import '../widgets/class_filter_drawer.dart';
import '../widgets/class_header.dart';



class ClassListPage extends StatefulWidget {
  final String schoolId; // Passa l'ID della scuola alla pagina

  const ClassListPage({super.key, required this.schoolId});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  // Variabili per i filtri
  String? _selectedCycle;
  String? _selectedLevel;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Inizializza il ClassProvider con l'ID della scuola
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClassProvider>(context, listen: false).init(widget.schoolId);
    });
  }

  // Funzione per mostrare il formulario di aggiunta/modifica
  void _showAddEditClassForm({Class? classToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permette alla bottom sheet di occupare più spazio
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddEditClassForm(classToEdit: classToEdit, schoolId:widget.schoolId ,),
        );
      },
    );
  }

  // Metodo per applicare i filtri e la ricerca
  List<Class> _getFilteredClasses(List<Class> allClasses) {
    List<Class> filteredClasses = allClasses;

    if (_selectedCycle != null && _selectedCycle!.isNotEmpty) {
      filteredClasses = filteredClasses
          .where((c) => c.cycle.toLowerCase() == _selectedCycle!.toLowerCase())
          .toList();
    }

    if (_selectedLevel != null && _selectedLevel!.isNotEmpty) {
      filteredClasses = filteredClasses
          .where((c) => c.level.toLowerCase() == _selectedLevel!.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredClasses = filteredClasses
          .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredClasses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Classes'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Colore primario del tema
      ),
      drawer: MediaQuery.of(context).size.width < 768
          ? ClassFilterDrawer(
              selectedCycle: _selectedCycle,
              selectedLevel: _selectedLevel,
              searchQuery: _searchQuery,
              onCycleChanged: (cycle) {
                setState(() {
                  _selectedCycle = cycle;
                });
                Navigator.pop(context); // Chiudi il drawer dopo la selezione
              },
              onLevelChanged: (level) {
                setState(() {
                  _selectedLevel = level;
                });
                Navigator.pop(context); // Chiudi il drawer dopo la selezione
              },
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            )
          : null, // Nessun drawer su schermi più grandi
      body: Consumer<ClassProvider>(
        builder: (context, classProvider, child) {
          if (classProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (classProvider.error != null) {
            return Center(
              child: Text(
                'Erreur: ${classProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final filteredClasses = _getFilteredClasses(classProvider.classes);

          return LayoutBuilder(
            builder: (context, constraints) {
              // Determinare il numero di colonne per la griglia
              int crossAxisCount;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1; // Mobile
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 2; // Tablet
              } else {
                crossAxisCount = 3; // Desktop
              }

              return Row(
                children: [
                  // Filtri fissi per tablet e desktop
                  if (constraints.maxWidth >= 768)
                    Container(
                      width: 250, // Larghezza fissa per i filtri
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(2, 0), // Ombra a destra
                          ),
                        ],
                      ),
                      child: ClassFilterDrawer(
                        selectedCycle: _selectedCycle,
                        selectedLevel: _selectedLevel,
                        searchQuery: _searchQuery,
                        onCycleChanged: (cycle) {
                          setState(() {
                            _selectedCycle = cycle;
                          });
                        },
                        onLevelChanged: (level) {
                          setState(() {
                            _selectedLevel = level;
                          });
                        },
                        onSearchChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        // Header opzionale
                        ClassHeader(
                          totalClasses: filteredClasses.length,
                          totalStudents: 0, // Segnaposto, da implementare
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 3 / 2, // Adatta l'aspetto delle carte
                            ),
                            itemCount: filteredClasses.length + 1, // +1 per la carta "Aggiungi Classe"
                            itemBuilder: (context, index) {
                              if (index == filteredClasses.length) {
                                // Carta "Aggiungi Classe"
                                return ClassAddCard(
                                  onTap: () => _showAddEditClassForm(),
                                );
                              }
                              final classe = filteredClasses[index];
                              return ClassCard(
                                classe: classe,
                                onEdit: () => _showAddEditClassForm(classToEdit: classe),
                                onDelete: () async {
                                  // Conferma eliminazione
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirmer la suppression'),
                                      content: Text(
                                          'Voulez-vous vraiment supprimer la classe "${classe.name}" ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Annuler'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text('Supprimer'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await classProvider.delete(classe.id);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      // FloatingActionButton per aggiungere su mobile
      floatingActionButton: MediaQuery.of(context).size.width < 768
          ? FloatingActionButton(
              onPressed: () => _showAddEditClassForm(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}