import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/course_session_model.dart';
import '../../class/provider/class_provider.dart';
import '../../subject/provider/subject_provider.dart';
import '../../teacher/provider/teacher_provider.dart';

class CourseSessionDetailPage extends StatelessWidget {
  final CourseSession session;

  const CourseSessionDetailPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final className = context.read<ClassProvider>().getById(session.classId)?.name ?? 'Classe inconnue';
    final subjectName = context.read<SubjectProvider>().getById(session.subjectId)?.name ?? 'Matière inconnue';
    final teacherName = context.read<TeacherProvider>().getById(session.teacherId)?.fullName ?? 'Enseignant inconnu';

    final dayNames = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final day = session.dayOfWeek >= 1 && session.dayOfWeek <= 7 ? dayNames[session.dayOfWeek - 1] : 'Jour inconnu';

    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la session')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Classe : $className', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text('Matière : $subjectName', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text('Enseignant : $teacherName', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text('Jour : $day', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text(
                  'Heure : ${session.startTime.format(context)} - ${session.endTime.format(context)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                /*ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Afficher les leçons associées
                  },
                  icon: const Icon(Icons.book_outlined),
                  label: const Text('Voir les leçons associées'),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
