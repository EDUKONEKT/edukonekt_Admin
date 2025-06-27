import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'student_form_page.dart';
import 'student_search_delegate.dart';

class StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StudentAppBar({super.key, required this.searchQuery, required this.onSearchChanged, required this.schoolId, required String initialQuery});
  final String searchQuery; final ValueChanged<String> onSearchChanged; final String schoolId;
  @override Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      title: Text('students'.tr()),
      actionsIconTheme: IconThemeData(color: cs.onPrimary),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'search'.tr(),
          onPressed: () async {
            final result = await showSearch<String?>(context: context, delegate: StudentSearchDelegate(initial: searchQuery));
            if (result != null) onSearchChanged(result);
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'add_student'.tr(),
          onPressed: () async {
            await Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => StudentFormPage(schoolId: schoolId), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child)));
          },
        ),
      ],
    );
  }
}