import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../class/provider/class_provider.dart';
import '../provider/student_provider.dart';
import '../../../core/models/student_model.dart';
import '../widgets/student_app_bar.dart';
import '../widgets/student_card.dart';
import '../widgets/student_filter_drawer.dart';
import '../widgets/student_summary_bar.dart';


class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key, required this.schoolId});

  final String schoolId;

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  String? _selectedCycle;
  String? _selectedClassId;
  String _searchQuery = '';



  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final studentProvider = context.watch<StudentProvider>();

    List<Student> filtered = studentProvider.students.where((s) {
      final matchesCycle = _selectedCycle == null ||
          classProvider.classes
              .firstWhere((c) => c.id == s.classId)
              .cycle ==
              _selectedCycle;
      final matchesClass =
          _selectedClassId == null || s.classId == _selectedClassId;
      final matchesSearch = s.fullName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCycle && matchesClass && matchesSearch;
    }).toList();

    final total = filtered.length;
    final totalGirls =
        filtered.where((s) => s.gender.toLowerCase() == 'f').length;
    final totalBoys = total - totalGirls;

    return Scaffold(
      body: Row(
        children: [
          StudentFilterDrawer(
            selectedCycle: _selectedCycle,
            selectedClassId: _selectedClassId,
            onCycleChanged: (val) => setState(() => _selectedCycle = val),
            onClassChanged: (val) => setState(() => _selectedClassId = val),
          ),
          Expanded(
            child: Column(
              children: [
                StudentAppBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (val) => setState(() => _searchQuery = val), 
                  schoolId: widget.schoolId,
                 ),
                StudentSummaryBar(total: total, girls: totalGirls, boys: totalBoys),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return StudentCard(
                          student: filtered[index],
                          className: classProvider.classes
                              .firstWhere((c) => c.id == filtered[index].classId)
                              .name,
                          onTap: () {
                            // TODO : navigation vers la fiche détails
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}