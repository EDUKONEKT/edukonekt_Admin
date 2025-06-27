
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

// === CORE MODELS ===
import '../../../core/models/student_model.dart';
import '../../../core/models/parent_model.dart';

// === PROVIDERS ===
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
    if (_selectedClassId == null || _gender == null || _birthDate == null || _selectedUserRole == null) return;

    setState(() => _loading = true);
    final id = const Uuid().v4();

    final student = Student(
      id: id,
      fullName: _nameCtrl.text.trim(),
      gender: _gender!,
      birthDate: _birthDate!,
      classId: _selectedClassId!,
      schoolFeeId: '',
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
      final parentFullName = {
        'father'.tr(): _fatherName.text,
        'mother'.tr(): _motherName.text,
        'tutor'.tr(): _tutorName.text,
      }[_selectedUserRole]!.trim();

      final phone = {
        'father'.tr(): _fatherPhone.text,
        'mother'.tr(): _motherPhone.text,
        'tutor'.tr(): _tutorPhone.text,
      }[_selectedUserRole]!.trim();

      final existing = await parentProvider.findByPhone(phone);
      if (existing != null) {
        await studentProvider.addStudent(student.copyWith(parentId: existing.id));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student joined to an existing parent'.tr())));
      } else {
        final email = _generateEmailFromName(parentFullName);
        final password = _generatePassword();

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
          plainPassword: password,
          parentT: parent,
          studentTemplate: student,
        );

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('parent_account_created'.tr()),
            content: Text('Email: $email\nMot de passe: $password'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${'error'.tr()}: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final classProvider = context.watch<ClassProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('New Student'.tr()),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  _buildSectionTitle(context, '👦 ${'student_info'.tr()}'),
                  _buildCard(context, children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(labelText: 'full_name'.tr()),
                      validator: (v) => v == null || v.isEmpty ? 'required'.tr() : null,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('gender_boy'.tr()),
                            value: 'M',
                            groupValue: _gender,
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('gender_girl'.tr()),
                            value: 'F',
                            groupValue: _gender,
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _dobCtrl,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'birth_date'.tr()),
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
                      decoration: InputDecoration(labelText: 'Class'.tr()),
                    ),
                    TextFormField(
                      controller: _specCtrl,
                      decoration: InputDecoration(labelText: 'specificities'.tr()),
                      maxLines: 2,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, '👨‍👩‍👧 ${'parents_tutors'.tr()}'),
                  _buildParentRow(context, 'father'.tr(), Icons.man, _fatherName, _fatherPhone, _fatherAddr, 'father'),
                  _buildParentRow(context, 'mother'.tr(), Icons.woman, _motherName, _motherPhone, _motherAddr, 'mother'),
                  _buildParentRow(context, 'tutor'.tr(), Icons.shield, _tutorName, _tutorPhone, _tutorAddr, 'tutor'),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: Text('submit'.tr()),
        backgroundColor: colorScheme.secondary,
        onPressed: _submit,
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );
  }

  Widget _buildParentRow(
    BuildContext context,
    String label,
    IconData icon,
    TextEditingController nameCtrl,
    TextEditingController phoneCtrl,
    TextEditingController addrCtrl,
    String role,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedUserRole == role;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? theme.colorScheme.secondary.withOpacity(0.1) : theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Radio<String>(
                  value: role,
                  groupValue: _selectedUserRole,
                  onChanged: (v) => setState(() => _selectedUserRole = v),
                  activeColor: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Text('account'.tr()),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: 'full_name'.tr()),
            ),
            TextFormField(
              controller: phoneCtrl,
              decoration: InputDecoration(labelText: 'phone'.tr()),
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (_selectedUserRole == role && (val == null || val.isEmpty)) {
                  return 'required_for_selected_parent'.tr();
                }
                return null;
              },
            ),
            TextFormField(
              controller: addrCtrl,
              decoration: InputDecoration(labelText: 'address'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  String _generateEmailFromName(String fullName) {
    final parts = fullName.trim().toLowerCase().split(RegExp(r'\s+'));
    if (parts.length == 1) return '${parts.first}@edukonekt.com';
    return '${parts.first}.${parts.last}@edukonekt.com';
  }

  String _generatePassword({int length = 8}) {
    const chars = 'AaBbCcDdEeFfGgHhJjKkMmNnPpQqRrSsTtUuVvWwXxYyZz23456789';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
