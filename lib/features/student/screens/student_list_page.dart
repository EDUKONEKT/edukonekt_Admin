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
  @override State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  String? _selectedCycle; String? _selectedClassId; String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final studentProvider = context.watch<StudentProvider>();

    List<Student> filtered = studentProvider.students.where((s) {
      final matchesCycle = _selectedCycle == null || classProvider.classes.firstWhere((c) => c.id == s.classId).cycle == _selectedCycle;
      final matchesClass = _selectedClassId == null || s.classId == _selectedClassId;
      final matchesSearch = s.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCycle && matchesClass && matchesSearch;
    }).toList();

    final total = filtered.length;
    final totalGirls = filtered.where((s) => s.gender.toLowerCase() == 'f').length;
    final totalBoys = total - totalGirls;

    return Scaffold(
      body: Column(children: [
        StudentAppBar(searchQuery: _searchQuery, onSearchChanged: (v) => setState(() => _searchQuery = v), schoolId: widget.schoolId, initialQuery: '',),
        StudentSummaryBar(total: total, girls: totalGirls, boys: totalBoys),
        Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StudentFilterDrawer(selectedCycle: _selectedCycle, selectedClassId: _selectedClassId, onCycleChanged: (v) => setState(() => _selectedCycle = v), onClassChanged: (v) => setState(() => _selectedClassId = v)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, mainAxisExtent: 110, mainAxisSpacing: 12, crossAxisSpacing: 12),
                  itemBuilder: (context, idx) {
                    final student = filtered[idx];
                    final className = classProvider.classes.firstWhere((c) => c.id == student.classId).name;
                    return ModernStudentCard(student: student, className: className, onTap: () {});
                  },
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}