import 'package:flutter/material.dart';

import '../../../core/models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  const TeacherCard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final isFemale = teacher.gender.toLowerCase() == 'f';
    final avatarAsset = isFemale
        ? 'lib/image/avatar_prof_femme.png'
        : 'lib/image/avatar_prof_homme.png';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(avatarAsset),
            ),
            const SizedBox(height: 8),
            Text(teacher.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(teacher.email),
            Text(teacher.phone),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: teacher.subjects
                  .map((subj) => Chip(label: Text(subj)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}