//import 'package:edukonekt_admin/core/utils/startup_screen.dart';
//import 'package:edukonekt_admin/features/dashboard/screen/dashboard_page.dart';
import 'package:edukonekt_admin/features/absence/provider/absence_provider.dart';
import 'package:edukonekt_admin/features/course_session/provider/course_session_provider.dart';
import 'package:edukonekt_admin/features/exercice/provider/exercise_provider.dart';
import 'package:edukonekt_admin/features/lesson/provider/lesson_provider.dart';
import 'package:edukonekt_admin/features/parent/provider/parent_provider.dart';
import 'package:edukonekt_admin/features/schoolsettings/school_setting_provider.dart';
import 'package:edukonekt_admin/features/student/provider/student_provider.dart';
import 'package:edukonekt_admin/features/teacher/provider/teacher_provider.dart';
import 'package:edukonekt_admin/features/teacher_assignment/provider/teacher_assignment_provider.dart';
import 'package:edukonekt_admin/features/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/services/firebase_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/class/provider/class_provider.dart';
import 'features/school/provider/school_provider.dart';
import 'features/schoolfee/provider/ValidatedInstallmentGridsProvider.dart';
import 'features/schoolfee/provider/installment_grid_provider.dart';
import 'features/subject/provider/subject_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  await FirebaseService.enableOfflinePersistence();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ValidatedInstallmentGridsProvider()),
        ChangeNotifierProvider(create: (_) => InstallmentGridProvider()),
        ChangeNotifierProvider(create: (_) => SchoolProvider()),
        ChangeNotifierProvider(create: (_) => InstallmentGridProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => CourseSessionProvider()),
        ChangeNotifierProvider(create: (_) => TeacherAssignmentProvider()),
        ChangeNotifierProvider(create: (_) => AbsenceProvider()),
        ChangeNotifierProvider(create: (_) => SchoolSettingProvider())
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'lib/core/l10n',
        fallbackLocale: const Locale('fr'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupère une seule fois le ThemeProvider
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Admin',

      // 🌍 Localisation
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // 🎨 Thèmes issus du provider
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,

      home: const LoginScreen(),
    );
  }
}
