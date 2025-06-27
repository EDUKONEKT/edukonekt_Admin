import 'package:edukonekt_admin/features/schoolsettings/school_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/absence/provider/absence_provider.dart';
import '../../features/course_session/provider/course_session_provider.dart';
import '../../features/exercice/provider/exercise_provider.dart';
import '../../features/lesson/provider/lesson_provider.dart';
import '../../features/student/provider/student_provider.dart';
import '../../features/class/provider/class_provider.dart';
import '../../features/parent/provider/parent_provider.dart';
import '../../features/subject/provider/subject_provider.dart';
import '../../features/teacher/provider/teacher_provider.dart';
import '../../features/teacher_assignment/provider/teacher_assignment_provider.dart';
import '../../features/user/provider/user_provider.dart';
import '../../features/schoolfee/provider/installment_grid_provider.dart';

class AppCleaner {
  static void disposeAllStreams(BuildContext context) {
    context.read<StudentProvider>().dispose();
    context.read<ParentProvider>().dispose();
    context.read<ClassProvider>().dispose();
    context.read<UserProvider>().dispose();
    context.read<InstallmentGridProvider>().clear(); // pas de stream, mais nettoie
    context.read<TeacherProvider>().dispose();
    context.read<SubjectProvider>().dispose();
    context.read()<LessonProvider>().dispose();
    context.read()<CourseSessionProvider>().dispose();
    context.read()<ExerciseProvider>().dispose();
    context.read()<AbsenceProvider>().dispose();
    context.read()<TeacherAssignmentProvider>().dispose();
    context.read()<SchoolSettingProvider>().dispose();
  }
}
