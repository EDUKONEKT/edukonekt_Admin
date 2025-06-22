// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:edukonekt_admin/core/models/student_model.dart';
import 'package:edukonekt_admin/core/models/parent_model.dart';
import '../../class/provider/class_provider.dart';
import '../../student/provider/student_provider.dart';
import '../../parent/provider/parent_provider.dart';

class StudentFormPage extends StatefulWidget {
  final String schoolId;
  const StudentFormPage({super.key, required this.schoolId});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Élève
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  String? _gender;
  String? _selectedClassId;
  DateTime? _birthDate;

  // Parents
  final _fatherName = TextEditingController();
  final _motherName = TextEditingController();
  final _tutorName = TextEditingController();

  final _fatherPhone = TextEditingController();
  final _motherPhone = TextEditingController();
  final _tutorPhone = TextEditingController();

  final _fatherAddr = TextEditingController();
  final _motherAddr = TextEditingController();
  final _tutorAddr = TextEditingController();

  String? _selectedUserRole; // 'father', 'mother', 'tutor'
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _specCtrl.dispose();
    _fatherName.dispose();
    _motherName.dispose();
    _tutorName.dispose();
    _fatherPhone.dispose();
    _motherPhone.dispose();
    _tutorPhone.dispose();
    _fatherAddr.dispose();
    _motherAddr.dispose();
    _tutorAddr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClassId == null || _gender == null || _birthDate == null) return;
    if (_selectedUserRole == null) return;

    setState(() => _loading = true);

    final id = const Uuid().v4();
    final student = Student(
      id: id,
      fullName: _nameCtrl.text.trim(),
      gender: _gender!,
      birthDate: _birthDate!,
      classId: _selectedClassId!,
      schoolFeeId: '', // à remplir dynamiquement si besoin
      specificities: _specCtrl.text.trim(),
      profilePictureUrl: '',
      parentId: '',
      isSynced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final parentProvider = context.read<ParentProvider>();
    final studentProvider = context.read<StudentProvider>();

    try {
      // Extraire infos selon rôle sélectionné
      final parentFullName = {
        'father': _fatherName.text,
        'mother': _motherName.text,
        'tutor': _tutorName.text,
      }[_selectedUserRole]!.trim();

      final phone = {
        'father': _fatherPhone.text,
        'mother': _motherPhone.text,
        'tutor': _tutorPhone.text,
      }[_selectedUserRole]!.trim();

    

      final existing = await parentProvider.findByPhone(phone);
      if (existing != null) {
        await studentProvider.addStudent(student.copyWith(parentId: existing.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Élève lié à un parent existant')),
        );
      } else {
        final email = generateEmailFromName(parentFullName);
        final password = _generatePassword;

        final parent = Parent(
          id: const Uuid().v4(),
          userId: '',
          fatherfullName: _fatherName.text.trim(),
          motherfullName: _motherName.text.trim(),
          tutorfullName: _tutorName.text.trim(),
          fatherPhone: _fatherPhone.text.trim(),
          motherPhone: _motherPhone.text.trim(),
          tutorPhone: _tutorPhone.text.trim(),
          fatherAddress: _fatherAddr.text.trim(),
          motherAddress: _motherAddr.text.trim(),
          tutorAddress: _tutorAddr.text.trim(),
          isSynced: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await studentProvider.createStudentWithParent(
          parentEmail: email,
          plainPassword: password.toString(),
          parentT: parent,
          studentTemplate: student,
        );

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Compte parent créé"),
            content: Text("Email: $email\nMot de passe: $password"),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Nouvel élève")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Informations Élève", style: TextStyle(fontSize: 18)),
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(labelText: "Nom complet"),
                            validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Garçon"),
                                  value: "M",
                                  groupValue: _gender,
                                  onChanged: (v) => setState(() => _gender = v),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Fille"),
                                  value: "F",
                                  groupValue: _gender,
                                  onChanged: (v) => setState(() => _gender = v),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: _dobCtrl,
                            decoration: const InputDecoration(labelText: "Date de naissance"),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2010),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _birthDate = date;
                                  _dobCtrl.text = DateFormat('dd/MM/yyyy').format(date);
                                });
                              }
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedClassId,
                            items: classProvider.classes
                                .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                                .toList(),
                            onChanged: (v) => setState(() => _selectedClassId = v),
                            decoration: const InputDecoration(labelText: "Classe"),
                          ),
                          TextFormField(
                            controller: _specCtrl,
                            decoration: const InputDecoration(labelText: "Spécificités"),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Parents / Tuteurs", style: TextStyle(fontSize: 18)),
                          _buildParentRow("Père", _fatherName, _fatherPhone, _fatherAddr, "father"),
                          _buildParentRow("Mère", _motherName, _motherPhone, _motherAddr, "mother"),
                          _buildParentRow("Tuteur", _tutorName, _tutorPhone, _tutorAddr, "tutor"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: const Text("Enregistrer"),
        onPressed: _submit,
      ),
    );
  }

  Widget _buildParentRow(
    String label,
    TextEditingController nameCtrl,
    TextEditingController phoneCtrl,
    TextEditingController addrCtrl,
    String role,
  ) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(child: Text(label)),
            Radio<String>(
              value: role,
              groupValue: _selectedUserRole,
              onChanged: (v) => setState(() => _selectedUserRole = v),
            ),
            const Text("Compte"),
          ],
        ),
        TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: "Nom complet"),
        ),
        TextFormField(
          controller: phoneCtrl,
          decoration: const InputDecoration(labelText: "Téléphone"),
          validator: (val) {
            if (_selectedUserRole == role && (val == null || val.isEmpty)) {
              return "Requis pour le parent sélectionné";
            }
            return null;
          },
        ),
        TextFormField(
          controller: addrCtrl,
          decoration: const InputDecoration(labelText: "Adresse"),
        ),
      ],
    );
  }

   String generateEmailFromName(String fullName) {
  final parts = fullName.trim().toLowerCase().split(RegExp(r'\s+'));

  if (parts.length == 1) {
    return '${parts.first}@edukonekt.com';
  } else {
    final firstName = parts.first;
    final lastName = parts.last;
    return '$firstName.$lastName@edukonekt.com';
  }
}
 String _generatePassword({int length = 8}) {
    const chars = 'AaBbCcDdEeFfGgHhJjKkMmNnPpQqRrSsTtUuVvWwXxYyZz23456789';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
  }

}
