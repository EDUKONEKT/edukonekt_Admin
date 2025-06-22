import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edukonekt_admin/providers/theme_provider.dart';
import 'package:edukonekt_admin/features/auth/widgets/auth_form.dart';
import 'package:edukonekt_admin/features/auth/providers/auth_provider.dart';
import 'package:edukonekt_admin/features/dashboard/screen/dashboard_page.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/utils/startup_screen.dart';
import '../../class/provider/class_provider.dart';
import '../../parent/provider/parent_provider.dart';
import '../../student/provider/student_provider.dart';
import '../../user/provider/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider authProvider) async {
  if (!_formKey.currentState!.validate()) return;

  authProvider.clearError();

  final success = await authProvider.signIn(
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  if (!mounted) return;

  if (success) {
    if (authProvider.schoolId == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StartupScreen()),
      );
    } else {
      // 🔐 Très important : s’assurer que Firestore connaît l’utilisateur connecté
      await fb_auth.FirebaseAuth.instance.authStateChanges().firstWhere((user) => user != null);


      final classProv = context.read<ClassProvider>();
      final parentProv = context.read<ParentProvider>();
      final userProv = context.read<UserProvider>();
      final studentProv = context.read<StudentProvider>();

      await classProv.init(authProvider.schoolId.toString());
      debugPrint('📚 Classes : ${classProv.classes.length}');
      await parentProv.init(authProvider.schoolId.toString());
      await userProv.init();
      await studentProv.init(
        schoolId: authProvider.schoolId.toString(),
        parentService: parentProv.service,
        userService: userProv.service,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DashboardPage(schoolId: authProvider.schoolId!)),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'lib/image/logo.jpeg',
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                tr('auth.login_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: AuthForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  errorMessage: authProvider.errorMessage,
                  isLoading: authProvider.isLoading,
                  submitFn: (_, __) => _submit(authProvider),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeProvider.toggleTheme();
        },
        child: Icon(
          themeProvider.themeMode == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode,
        ),
      ),
    );
  }
}
