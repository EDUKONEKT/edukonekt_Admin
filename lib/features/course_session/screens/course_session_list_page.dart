import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../class/provider/class_provider.dart';
import '../../subject/provider/subject_provider.dart';
import '../../teacher/provider/teacher_provider.dart';
import '../provider/course_session_provider.dart';
import '../widgets/course_details_page.dart';
import '../widgets/course_session_form_dialog.dart';


class CourseSessionListPage extends StatelessWidget {
  const CourseSessionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<CourseSessionProvider>();
    final classProvider = context.watch<ClassProvider>();
    final subjectProvider = context.watch<SubjectProvider>();
    final teacherProvider = context.watch<TeacherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('course_sessions'.tr()),
      ),
      body: sessionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sessionProvider.sessions.length,
              itemBuilder: (context, index) {
                final session = sessionProvider.sessions[index];
                final className = classProvider.getById(session.classId)?.name ?? 'unknown_class'.tr();
                final subjectName = subjectProvider.getById(session.subjectId)?.name ?? 'unknown_subject'.tr();
                final teacherName = teacherProvider.getById(session.teacherId)?.fullName ?? 'unknown_teacher'.tr();

                return ListTile(
                  title: Text('$className - $subjectName'),
                  subtitle: Text('${'teacher'.tr()}: $teacherName\n'
                      '${'day'.tr()}: ${_dayOfWeekToText(session.dayOfWeek)}\n'
                      '${'time'.tr()}: ${session.startTime.format(context)} - ${session.endTime.format(context)}'),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await showDialog(
                          context: context,
                          builder: (_) => CourseSessionFormDialog(initial: session),
                        );
                      } else if (value == 'delete') {
                        await sessionProvider.deleteCourseSession(session.id);
                      } else if (value == 'details') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseSessionDetailPage(session: session),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text('edit'.tr())),
                      PopupMenuItem(value: 'delete', child: Text('delete'.tr())),
                      PopupMenuItem(value: 'details', child: Text('view_details'.tr())),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => const CourseSessionFormDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _dayOfWeekToText(int day) {
    switch (day) {
      case 1:
        return 'monday'.tr();
      case 2:
        return 'tuesday'.tr();
      case 3:
        return 'wednesday'.tr();
      case 4:
        return 'thursday'.tr();
      case 5:
        return 'friday'.tr();
      case 6:
        return 'saturday'.tr();
      case 7:
        return 'sunday'.tr();
      default:
        return 'unknown_day'.tr();
    }
  }
} 
