import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edukonekt_admin/features/user/provider/user_provider.dart';


import '../../features/teacher/provider/teacher_provider.dart';
import '../../features/user/service/user_service.dart';


class NetworkListener {

static bool _isSyncing = false;

static void startNetworkListener(TeacherProvider teacherProvider, UserProvider userProv) {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    final isConnected = result != ConnectivityResult.none;

    if (isConnected && !_isSyncing) {
      // Vérifie s'il y a des enseignants à synchroniser
      final hasPending = teacherProvider.teachers.any((t) => t.requiresAccount);
      if (!hasPending) {
        return; // Rien à faire
      }

      _isSyncing = true;
      print("🌐 Connexion détectée → Lancement de la synchronisation");

      try {
        await teacherProvider.syncPendingAccounts(userProv);
      } catch (e) {
        print("❌ Erreur pendant syncPendingAccounts : $e");
      } finally {
        _isSyncing = false;
      }
    }
  });
}



}
