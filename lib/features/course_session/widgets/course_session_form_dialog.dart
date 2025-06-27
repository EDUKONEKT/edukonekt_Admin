import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/course_session_model.dart';
import '../../../core/models/teacher_assignment_model.dart';
import '../../class/provider/class_provider.dart';
import '../../schoolsettings/school_setting_provider.dart';
import '../../subject/provider/subject_provider.dart';
import '../../teacher/provider/teacher_provider.dart';
import '../../teacher_assignment/provider/teacher_assignment_provider.dart';
import '../provider/course_session_provider.dart';
import 'occupied_slot_view.dart';


class CourseSessionFormDialog extends StatefulWidget {
  final CourseSession? initial;

  const CourseSessionFormDialog({super.key, this.initial});

  @override
  State<CourseSessionFormDialog> createState() => _CourseSessionFormDialogState();
}

class _CourseSessionFormDialogState extends State<CourseSessionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _classId;
  String? _subjectId;
  String? _teacherId;
  int? _dayOfWeek;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      final s = widget.initial!;
      _classId = s.classId;
      _subjectId = s.subjectId;
      _teacherId = s.teacherId;
      _dayOfWeek = s.dayOfWeek;
      _startTime = s.startTime;
      _endTime = s.endTime;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final teacherProvider = context.read<TeacherProvider>();
    if (_classId == null || _subjectId == null || _teacherId == null || _dayOfWeek == null || _startTime == null || _endTime == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Veuillez remplir tous les champs.')),
  );
  return;
}

    final teacher = teacherProvider.getById(_teacherId!);

    if (teacher != null && teacher.subjects.contains(_subjectId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cet enseignant a déjà cette matière assignée.')),
      );
      return;
    }

    final courseSessionProvider = context.read<CourseSessionProvider>();
    final sameDaySessions = courseSessionProvider.getByClassAndDay(_classId!, _dayOfWeek!);

    final conflict = sameDaySessions.any((s) {
      final start = s.startTime;
      final end = s.endTime;
      return !(_endTime!.hour * 60 + _endTime!.minute <= start.hour * 60 + start.minute ||
               _startTime!.hour * 60 + _startTime!.minute >= end.hour * 60 + end.minute);
    });

    if (conflict) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Un autre cours est déjà prévu à cette heure.')),
      );
      return;
    }

    final now = DateTime.now();
    final newSession = CourseSession(
      id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      classId: _classId!,
      subjectId: _subjectId!,
      teacherId: _teacherId!,
      dayOfWeek: _dayOfWeek!,
      startTime: _startTime!,
      endTime: _endTime!,
      academicYear: '',
      isSynced: false,
      createdAt: widget.initial?.createdAt ?? now,
      updatedAt: now,
    );

    final provider = context.read<CourseSessionProvider>();
    if (widget.initial == null) {
      await provider.addCourseSession(newSession);
    } else {
      await provider.updateCourseSession(newSession);
    }

    final assignment = TeacherAssignment(
      id: '${newSession.classId}_${newSession.subjectId}',
      classId: newSession.classId,
      subjectId: newSession.subjectId,
      teacherId: newSession.teacherId,
      academicYear: '',
      term: '',
      isActive: true,
      isSynced: false,
      visibleToTeacher: true,
      createdAt: now,
      updatedAt: now,
    );
    await context.read<TeacherAssignmentProvider>().addAssignment(assignment);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final subjectProvider = context.watch<SubjectProvider>();
    final teacherProvider = context.watch<TeacherProvider>();
    context.watch<CourseSessionProvider>();


    return AlertDialog(
      title: Text(widget.initial == null ? 'Ajouter une session' : 'Modifier la session'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _classId,
                items: classProvider.classes.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (val) => setState(() => _classId = val),
                decoration: const InputDecoration(labelText: 'Classe'),
                validator: (val) => val == null ? 'Veuillez sélectionner une classe' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _subjectId,
                items: subjectProvider.subjects.map((s) {
                  return DropdownMenuItem(value: s.id, child: Text(s.name));
                }).toList(),
                onChanged: (val) => setState(() => _subjectId = val),
                decoration: const InputDecoration(labelText: 'Matière'),
                validator: (val) => val == null ? 'Veuillez sélectionner une matière' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _teacherId,
                items: teacherProvider.teachers.map((t) {
                  return DropdownMenuItem(value: t.id, child: Text(t.fullName));
                }).toList(),
                onChanged: (val) => setState(() => _teacherId = val),
                decoration: const InputDecoration(labelText: 'Enseignant'),
                validator: (val) => val == null ? 'Veuillez sélectionner un enseignant' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _dayOfWeek,
                items: List.generate(6, (i) => i + 1).map((d) {
                  return DropdownMenuItem(value: d, child: Text(_dayName(d)));
                }).toList(),
                onChanged: (val) => setState(() => _dayOfWeek = val),
                decoration: const InputDecoration(labelText: 'Jour'),
                validator: (val) => val == null ? 'Veuillez sélectionner un jour' : null,
              ),
              const SizedBox(height: 12),
    if (_dayOfWeek != null && _classId != null) ...[
  const SizedBox(height: 16),
  Consumer2<CourseSessionProvider, SchoolSettingProvider>(
    builder: (context, courseSessionProvider, schoolSettingProvider, _) {
      final sessions = courseSessionProvider.getByClassAndDay(_classId!, _dayOfWeek!);
      final config = schoolSettingProvider.getDayConfig(_dayOfWeek!);

      final start = config.start;
      final end = config.end;
      final breaks = config.breaks;

      if (start == null || end == null) {
        return const Text('Aucune configuration horaire pour ce jour.');
      }

      return OccupiedSlotsView(
        sessionsOfDay: sessions,
        schoolStart: start,
        schoolEnd: end,
        breaks: breaks,
      );
    },
  ),
],


              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Heure début'),
                      child: InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _startTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) setState(() => _startTime = picked);
                        },
                        child: Text(_startTime?.format(context) ?? 'Choisir'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Heure fin'),
                      child: InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _endTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) setState(() => _endTime = picked);
                        },
                        child: Text(_endTime?.format(context) ?? 'Choisir'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.initial == null ? 'Ajouter' : 'Enregistrer'),
              ),
              const SizedBox(height: 8),
              if (widget.initial != null)
                TextButton(
                  onPressed: () {
                    // TODO: ouvrir la page de leçons associées à cette session
                  },
                  child: const Text('Voir les leçons associées'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _dayName(int d) {
    const days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
    return days[d - 1];
  }
}
