import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _firebaseUser;
  Map<String, dynamic>? _userData;

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _firebaseUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _firebaseUser;
  Map<String, dynamic>? get userData => _userData;

  String? get schoolId => _userData?['schoolId'] as String?;
  String? get role => _userData?['role'] as String?;

  /// Connexion de l’utilisateur
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(email, password);
      _firebaseUser = user;

      _userData = await _authService.fetchUserData(user!.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Erreur d’authentification.';
    } catch (e) {
      _errorMessage = 'Erreur inconnue.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _authService.signOut();
    _firebaseUser = null;
    _userData = null;
    notifyListeners();
  }

  /// Recharge le statut de session (si besoin plus tard)
  /*Future<void> tryAutoLogin() async {
    _firebaseUser = _authService.getCurrentUser();
    if (_firebaseUser != null) {
      _userData = await _authService.fetchUserData(_firebaseUser!.uid);
    }
    notifyListeners();
  }*/

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setSchoolId(String newSchoolId) {
    _userData?['schoolId'] = newSchoolId;
    notifyListeners();
  }
}
