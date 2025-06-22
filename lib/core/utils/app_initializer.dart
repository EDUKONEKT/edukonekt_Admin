import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../features/class/provider/class_provider.dart';
import '../../features/parent/provider/parent_provider.dart';
import '../../features/schoolfee/provider/installment_grid_provider.dart';
import '../../features/student/provider/student_provider.dart';
import '../../features/user/provider/user_provider.dart';

class AppInitializer {
  /// Lance *toutes* les initialisations liées à l’école [schoolId].
  static Future<void> initializeApp(BuildContext context, String schoolId) async {
    // 🔐 1) S’assurer que Firestore connaît bien l’utilisateur connecté
    await fb_auth.FirebaseAuth.instance
        .authStateChanges()
        .firstWhere((user) => user != null);

    // 2) Récupération des providers partagés
    final classProv   = context.read<ClassProvider>();
    final parentProv  = context.read<ParentProvider>();
    final userProv    = context.read<UserProvider>();
    final studentProv = context.read<StudentProvider>();
    final gridProv    = context.read<InstallmentGridProvider>();

    // 3) Initialisation synchrones
    await classProv.init(schoolId);
    await parentProv.init(schoolId);
    await userProv.init();
    await gridProv.init(schoolId);          // ← nouvelles grilles
    await studentProv.init(
      schoolId: schoolId,
      parentService: parentProv.service,
      userService:  userProv.service,
    );
  }
}
