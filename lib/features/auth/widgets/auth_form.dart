import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthForm extends StatelessWidget {
  final String? errorMessage;
  final bool isLoading;
  final void Function(String email, String password) submitFn;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AuthForm({
    super.key,
    this.errorMessage,
    this.isLoading = false,
    required this.submitFn,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Champ Adresse e-mail
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: tr('auth.email_label'), // Utilise la traduction
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return tr('auth.email_required'); // Utilise la traduction
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Champ Mot de passe
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: tr('auth.password_label'), // Utilise la traduction
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return tr('auth.password_required'); // Utilise la traduction
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Bouton Se connecter
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () => submitFn(emailController.text.trim(), passwordController.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    tr('auth.login_button'), // Utilise la traduction
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Message d'erreur
          if (errorMessage != null)
            Text(
              tr(errorMessage!), // Utilise la traduction pour le message d'erreur
              style: const TextStyle(
                color: Color(0xFFF97316),
              ),
            ),
        ],
      ),
    );
  }
}