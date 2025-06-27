import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../user/provider/user_provider.dart';
import '../provider/teacher_provider.dart';

class TeacherFormDialog extends StatefulWidget {
  final String schoolId;
  const TeacherFormDialog({super.key, required this.schoolId});

  @override
  State<TeacherFormDialog> createState() => _TeacherFormDialogState();
}

class _TeacherFormDialogState extends State<TeacherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController(); // Optionnel (peut servir plus tard)
  final _phoneController = TextEditingController();
  final List<String> _selectedSubjects = [];
  String _gender = 'f';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ajouter un enseignant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Nom complet'),
                  validator: (val) => val == null || val.isEmpty ? 'Nom requis' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                  validator: (val) => val == null || val.isEmpty ? 'Téléphone requis' : null,
                ),
                const SizedBox(height: 12),
                const Text('Genre'),
                Row(
                  children: [
                    Radio<String>(
                      value: 'f',
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                    const Text('Femme'),
                    Radio<String>(
                      value: 'm',
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                    const Text('Homme'),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Matières enseignées (IDs)'),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'ex: math,français,anglais'),
                  onChanged: (val) {
                    _selectedSubjects
                      ..clear()
                      ..addAll(val.split(',').map((s) => s.trim()));
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final teacherProv = context.read<TeacherProvider>();
    final userProv = context.read<UserProvider>();

    try {
      await teacherProv.createTeacherOffline(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _gender,
        subjects: _selectedSubjects,
        userService: userProv.service,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Enseignant enregistré avec succès')),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      final isOffline = e.toString().contains('offline-mode');
      final msg = isOffline
          ? '✅ Enseignant enregistré hors ligne. Le compte sera créé dès que la connexion revient.'
          : '❌ Une erreur est survenue : $e';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
