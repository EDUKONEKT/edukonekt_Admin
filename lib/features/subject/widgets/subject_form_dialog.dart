import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/models/subject_model.dart';
import '../provider/subject_provider.dart';

class SubjectFormDialog extends StatefulWidget {
  final Subject? subject;

  const SubjectFormDialog({super.key, this.subject});

  @override
  State<SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _descController;
  String? _selectedName;
  late bool isEdit;

  final List<String> _suggestedNames = [
    'Mathématiques', 'Physique', 'Informatique', 'Histoire',
    'Géographie', 'Anglais', 'Français', 'Sciences', 'Chimie', 'Sport',
    'Mathematics', 'Physics', 'Computer Science', 'History',
    'Geography', 'English', 'French', 'Science', 'Chemistry', 'PE',
    'Autre'
  ];

  @override
  void initState() {
    super.initState();
    isEdit = widget.subject != null;
    _selectedName = widget.subject?.name;
    _codeController = TextEditingController(text: widget.subject?.code ?? '');
    _descController = TextEditingController(text: widget.subject?.description ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'edit_subject_title'.tr() : 'add_subject_title'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  value: _selectedName,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'subject_name_label'.tr(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: _suggestedNames.map((name) => DropdownMenuItem(value: name, child: Text(name))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedName = val;
                    });
                  },
                  validator: (value) => (value == null || value.isEmpty) ? 'please_select_subject_name'.tr() : null,
                ),
                const SizedBox(height: 16),

                if (_selectedName == 'Autre')
                  TextFormField(
                    initialValue: widget.subject?.name,
                    decoration: InputDecoration(
                      labelText: 'custom_subject_name_label'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (val) => _selectedName = val,
                    validator: (val) => val == null || val.trim().isEmpty ? 'please_enter_subject_name'.tr() : null,
                  ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'subject_code_label'.tr(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'please_enter_subject_code'.tr() : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'subject_description_label'.tr(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    icon: Icon(isEdit ? Icons.save : Icons.add),
                    label: Text(isEdit ? 'save_button'.tr() : 'add_subject_button'.tr()),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      final subject = Subject(
                        id: widget.subject?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _selectedName!,
                        code: _codeController.text.trim(),
                        description: _descController.text.trim(),
                        isSynced: false,
                        createdAt: widget.subject?.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      final provider = context.read<SubjectProvider>();
                      try {
                        if (isEdit) {
                           provider.updateSubject(subject);
                        } else {
                           provider.addSubject(subject);
                        }

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isEdit ? 'subject_updated_success'.tr() : 'subject_added_success'.tr())),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${'error_occurred'.tr()}: ${e.toString()}')),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
