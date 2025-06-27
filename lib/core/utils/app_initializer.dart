import 'package:edukonekt_admin/core/utils/network_listener.dart';
import 'package:edukonekt_admin/features/teacher/provider/teacher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../features/absence/provider/absence_provider.dart';
import '../../features/class/provider/class_provider.dart';
import '../../features/course_session/provider/course_session_provider.dart';
import '../../features/exercice/provider/exercise_provider.dart';
import '../../features/lesson/provider/lesson_provider.dart';
import '../../features/parent/provider/parent_provider.dart';
import '../../features/schoolfee/provider/installment_grid_provider.dart';
import '../../features/schoolsettings/school_setting_provider.dart';
import '../../features/student/provider/student_provider.dart';
import '../../features/subject/provider/subject_provider.dart';
import '../../features/teacher_assignment/provider/teacher_assignment_provider.dart';
import '../../features/user/provider/user_provider.dart';

class AppInitializer {
  /// Lance *toutes* les initialisations liées à l’école [schoolId].
  static Future<void> initializeApp(BuildContext context, String schoolId) async {
    // 🔐 1) S’assurer que Firestore connaît bien l’utilisateur connecté
    await fb_auth.FirebaseAuth.instance
        .authStateChanges()
        .firstWhere((user) => user != null);

    // 2) Récupération des providers partagés
    final classProv   = context.read<ClassProvider>();
    final parentProv  = context.read<ParentProvider>();
    final userProv    = context.read<UserProvider>();
    final studentProv = context.read<StudentProvider>();
    final gridProv    = context.read<InstallmentGridProvider>();
    final teacherProv = context.read<TeacherProvider>();
    final subjectProv = context.read<SubjectProvider>();
    final lessonProv  = context.read<LessonProvider>();
    final courseSessionProv = context.read<CourseSessionProvider>();
    final exerciseProv =context.read<ExerciseProvider>();
    final absenceProv =context.read<AbsenceProvider>();
    final teacherAssignmentProv = context.read<TeacherAssignmentProvider>();
    final schoolSettingProv = context.read<SchoolSettingProvider>();


    // 3) Initialisation synchrones

    await classProv.init(schoolId);
    await parentProv.init(schoolId);
    await userProv.init();
    await gridProv.init(schoolId);          // ← nouvelles grilles
    await studentProv.init(
      schoolId: schoolId,
      parentService: parentProv.service,
      userService:  userProv.service,
    );
    await teacherProv.init(schoolId);
    await subjectProv.init(schoolId);
    await lessonProv.init(schoolId);
    await courseSessionProv.init(schoolId);
    await exerciseProv.init(schoolId);
    await absenceProv.init(schoolId);
    await teacherAssignmentProv.init(schoolId);
    await schoolSettingProv.init(schoolId);
  }
}