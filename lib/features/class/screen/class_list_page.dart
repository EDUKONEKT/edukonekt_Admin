import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/class_model.dart';
import '../provider/class_provider.dart';
import '../widgets/add_edit_class_form.dart';
import '../widgets/class_card.dart';
import '../widgets/class_filter_drawer.dart';
import '../widgets/class_header.dart';

class ClassListPage extends StatefulWidget {
  final String schoolId;
  const ClassListPage({super.key, required this.schoolId});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  String? _selectedCycle;
  String? _selectedLevel;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClassProvider>(context, listen: false).init(widget.schoolId);
    });
  }

  void _showAddEditClassForm({Class? classToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddEditClassForm(
            classToEdit: classToEdit,
            schoolId: widget.schoolId,
          ),
        );
      },
    );
  }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Classes', style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
                Navigator.pop(context);
              },
              onLevelChanged: (level) {
                setState(() {
                  _selectedLevel = level;
                });
                Navigator.pop(context);
              },
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            )
          : null,
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
              int crossAxisCount;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 3;
              }

              return Row(
                children: [
                  if (constraints.maxWidth >= 768)
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(2, 0),
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
                        ClassHeader(
                          totalClasses: filteredClasses.length,
                          totalStudents: 0,
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount: filteredClasses.length + 1,
                            itemBuilder: (context, index) {
                              if (index == filteredClasses.length) {
                                return ClassAddCard(
                                  onTap: () => _showAddEditClassForm(),
                                );
                              }
                              final classe = filteredClasses[index];
                              return ClassCard(
                                classe: classe,
                                onEdit: () => _showAddEditClassForm(classToEdit: classe),
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Confirm deletion'.tr()),
                                      content: Text(
                                        '${'Do you really want to delete the class'.tr()} "${classe.name}" ?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancel'.tr()),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: Text('Delete'.tr()),
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
      floatingActionButton: MediaQuery.of(context).size.width < 768
          ? FloatingActionButton(
              onPressed: () => _showAddEditClassForm(),
              backgroundColor: colorScheme.secondary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
