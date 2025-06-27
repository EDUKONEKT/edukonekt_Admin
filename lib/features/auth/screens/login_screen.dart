import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edukonekt_admin/providers/theme_provider.dart';
import 'package:edukonekt_admin/features/auth/widgets/auth_form.dart';
import 'package:edukonekt_admin/features/auth/providers/auth_provider.dart';
import 'package:edukonekt_admin/features/dashboard/screen/dashboard_page.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/utils/app_initializer.dart';
import '../../../core/utils/startup_screen.dart';


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
        // 🔐 Ensure Firestore knows the signed‑in user
        await fb_auth.FirebaseAuth.instance
            .authStateChanges()
            .firstWhere((user) => user != null);

       
        await AppInitializer.initializeApp(context, authProvider.schoolId!);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardPage(schoolId: authProvider.schoolId!),
          ),
        );
      }
    }
  }

  static const Color _kBackground = Color(0xFF0B1F45); // Deep blue
  static const Color _kAccent = Color(0xFFF4A300); // Orange
  static const Color _kFieldFill = Color(0xFFF1F1F1);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: _kBackground,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'lib/image/logo.jpeg',
                      height: 80,
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      tr('auth.login_title'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: _kBackground,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Form
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: _kFieldFill,
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: AuthForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          errorMessage: authProvider.errorMessage,
                          isLoading: authProvider.isLoading,
                          submitFn: (_, __) => _submit(authProvider),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _kAccent,
        onPressed: () {
          themeProvider.toggleTheme();
        },
        child: Icon(
          themeProvider.themeMode == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode,
          color: Colors.white,
        ),
      ),
    );
  }
}
