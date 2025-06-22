import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/student/provider/student_provider.dart';
import '../../features/class/provider/class_provider.dart';
import '../../features/parent/provider/parent_provider.dart';
import '../../features/user/provider/user_provider.dart';
import '../../features/schoolfee/provider/installment_grid_provider.dart';

class AppCleaner {
  static void disposeAllStreams(BuildContext context) {
    context.read<StudentProvider>().dispose();
    context.read<ParentProvider>().dispose();
    context.read<ClassProvider>().dispose();
    context.read<UserProvider>().dispose();
    context.read<InstallmentGridProvider>().clear(); // pas de stream, mais nettoie
  }
}
