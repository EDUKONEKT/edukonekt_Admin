import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/school/screen/school_setup_screen.dart';
import '../../features/schoolfee/screen/tuitionGridCreateScreen.dart';
import '../../features/dashboard/screen/dashboard_page.dart';

import '../../features/schoolfee/provider/installment_grid_provider.dart';
import 'app_initializer.dart';


class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleStartup());
  }

  Future<void> _handleStartup() async {
    final authProvider = context.read<AuthProvider>();

    // 1️⃣ Vérifier l'authentification
    if (!authProvider.isAuthenticated) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }

    // 2️⃣ Récupération ou création de l'ID d'école
    String? schoolId = authProvider.schoolId;
    if (schoolId == null || schoolId.isEmpty) {
      // ▶️ Création école
      final newSchoolId = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const SchoolSetupScreen()),
      );

      if (!mounted || newSchoolId == null || newSchoolId.isEmpty) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      authProvider.setSchoolId(newSchoolId);
      schoolId = newSchoolId;
    }

    // 3️⃣ Initialiser tous les providers en une seule fois
    await AppInitializer.initializeApp(context, schoolId);
    if (!mounted) return;

    // 4️⃣ Vérifier s'il existe déjà des grilles tarifaires
    final gridProvider = context.read<InstallmentGridProvider>();
    if (!gridProvider.hasGrids) {
      final created = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => TuitionGridCreateScreen(schoolId: schoolId!)),
      );

      if (!mounted || created != true) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      // Recharger après la création
      await gridProvider.loadGrids();
      if (!mounted) return;
    }

    // 5️⃣ Naviguer vers le dashboard
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DashboardPage(schoolId: schoolId!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
