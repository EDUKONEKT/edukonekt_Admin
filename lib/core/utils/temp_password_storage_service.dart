import 'package:shared_preferences/shared_preferences.dart';

class TempPasswordStorageService {
  static const String _prefix = 'tempPwd_';

  /// Enregistre un mot de passe temporaire lié à un userId
  static Future<void> savePassword(String userId, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('tempPwd_$userId', password);
}

  /// Récupère un mot de passe temporaire
  static Future<String?> getPassword(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_prefix$userId');
  }

  /// Supprime le mot de passe temporaire
  static Future<void> removePassword(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$userId');
  }

  /// Vérifie si un mot de passe existe pour un userId
  static Future<bool> exists(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('$_prefix$userId');
  }

  static Future<List<String>> listIds() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();

  // 🔍 On ne garde que les clés qui commencent par 'tempPwd_'
  return keys
      .where((k) => k.startsWith('tempPwd_'))
      .map((k) => k.replaceFirst('tempPwd_', ''))
      .toList();
}


}
