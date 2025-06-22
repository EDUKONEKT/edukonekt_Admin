import 'package:flutter/material.dart';
import '../../../core/models/student_model.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.className,
    required this.onTap,
  });

  final Student student;
  final String className;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(student.fullName.substring(0, 1).toUpperCase()),
      ),
      title: Text(student.fullName),
      subtitle: Text(className),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
