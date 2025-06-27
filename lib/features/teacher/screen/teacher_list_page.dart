// 📄 teacher_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teacher_provider.dart';
import '../widgets/teacher_card.dart';
import '../widgets/teacher_filter_drawer.dart';
import '../widgets/teacher_form_dialog.dart';
import '../widgets/teacher_search_delegate.dart';

class TeacherListPage extends StatelessWidget {
  final String schoolId;
  const TeacherListPage({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherProvider>();
    final teachers = provider.teachers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('👩‍🏫 Enseignants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              showSearch(
                context: context,
                delegate: TeacherSearchDelegate(initialList: teachers),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => TeacherFormDialog(schoolId: schoolId),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          const TeacherFilterDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: teachers.map((t) => TeacherCard(teacher: t)).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}