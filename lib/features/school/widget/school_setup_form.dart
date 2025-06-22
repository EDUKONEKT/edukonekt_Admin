import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/models/school.dart';
import '../../auth/providers/auth_provider.dart';
import '../provider/school_provider.dart';

class SchoolSetupForm extends StatefulWidget {
  const SchoolSetupForm({super.key});

  @override
  State<SchoolSetupForm> createState() => _SchoolSetupFormState();
}

class _SchoolSetupFormState extends State<SchoolSetupForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  String _selectedPlan = 'standard';

  @override
  void initState() {
    super.initState();
    final school = context.read<SchoolProvider>().school;
    _nameController = TextEditingController(text: school?.name ?? '');
    _yearController = TextEditingController(text: school?.schoolYear ?? '2025-2026');
    _selectedPlan = school?.tariffPlan ?? 'standard';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

void _submit() async {
  if (!_formKey.currentState!.validate()) return;

  final authProvider = context.read<AuthProvider>();
  final uid = authProvider.user?.uid;

  if (uid == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur : utilisateur non authentifié')),
    );
    return;
  }

  final newSchoolRef = FirebaseFirestore.instance.collection('schools').doc();
  final newSchoolId = newSchoolRef.id;

  final newSchool = School(
    id: newSchoolId,
    name: _nameController.text.trim(),
    schoolYear: _yearController.text.trim(),
    tariffPlan: _selectedPlan,
  );

  try {
    // 1. Création du document école
    await newSchoolRef.set(newSchool.toMap());

    // 2. Mise à jour du user avec l’id de l’école
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'schoolId': newSchoolId,
    });

    // 3. Mise à jour locale
    authProvider.setSchoolId(newSchoolId);

    // 4. Fermer le formulaire et retourner l’id de l’école
    if (mounted) Navigator.of(context).pop(newSchoolId);
  } catch (e) {
    debugPrint('Erreur création école : $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur lors de la création de l’école')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<SchoolProvider>().isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'SchoolFee.school_name'.tr()),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _yearController,
            decoration: InputDecoration(labelText: 'SchoolFee.school_year'.tr()),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          DropdownButtonFormField<String>(
            value: _selectedPlan,
            items: const [
              DropdownMenuItem(value: 'standard', child: Text('Standard')),
              DropdownMenuItem(value: 'premium', child: Text('Premium')),
              DropdownMenuItem(value: 'gold', child: Text('Gold')),
            ],
            onChanged: (value) => setState(() => _selectedPlan = value ?? 'standard'),
            decoration: InputDecoration(labelText: 'SchoolFee.tariff_plan'.tr()),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: Text('SchoolFee.save'.tr()),
          ),
        ],
      ),
    );
  }
}
