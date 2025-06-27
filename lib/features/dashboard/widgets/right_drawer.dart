import 'package:easy_localization/easy_localization.dart';
import 'package:edukonekt_admin/features/class/screen/class_list_page.dart';
import 'package:edukonekt_admin/features/course_session/screens/course_session_list_page.dart';
import 'package:edukonekt_admin/features/schoolsettings/school_setting_main_page.dart';
import 'package:edukonekt_admin/features/student/screens/student_list_page.dart';
import 'package:edukonekt_admin/features/subject/screen/subject_list_page.dart';
import 'package:edukonekt_admin/features/teacher/screen/teacher_list_page.dart';
import 'package:flutter/material.dart';
import '../../schoolfee/screen/tuition_main_screen.dart';

class RightDrawer extends StatefulWidget {
  final String schoolId;
  const RightDrawer({super.key, required this.schoolId});

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  bool _isCollapsed = false;

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 70 : 240,
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            if (!_isCollapsed)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'lib/image/logo.jpeg',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'dashboard',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            IconButton(
              icon: Icon(_isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: _toggleCollapse,
            ),
            _buildIconItem(Icons.people, 'dashboard.students'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => StudentListPage(schoolId: widget.schoolId)),
              );
            }),
             const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.family_restroom, 'dashboard.parents'.tr(), () {}),
             const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.school, 'dashboard.teachers'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TeacherListPage(schoolId: widget.schoolId)),
              );
            }),
            const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.book, 'dashboard.subjects'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SubjectListPage()),
              );
            }),
            const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.grade, 'dashboard.grades'.tr(), () {}),
            const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.report, 'dashboard.reports'.tr(), () {}),
            const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.class_, 'dashboard.classes'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ClassListPage(schoolId: widget.schoolId)),
              );
            }),
            const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.book, 'dashboard.courses'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CourseSessionListPage()),
              );
            }),
             const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.schedule, 'dashboard.schedule'.tr(), () {}),
             const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.calendar_today, 'dashboard.calendar'.tr(), () {}),
             const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.message, 'dashboard.messages'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SchoolSettingMainPage()),
              );
            }),
             const Divider(color: Color.fromARGB(249, 248, 139, 43), thickness: 0.5),
            _buildIconItem(Icons.settings, 'dashboard.settings'.tr(), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => InstallmentGridListDialog(schoolId: widget.schoolId)),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            if (!_isCollapsed) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}