import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Connexion avec gestion des erreurs
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Aucun utilisateur trouvé pour cet email.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Mot de passe incorrect.');
      } else if (e.code == 'network-request-failed') {
        throw AuthException('Pas de connexion internet.');
      } else {
        throw AuthException('Erreur d\'authentification : ${e.message}');
      }
    } catch (_) {
      throw AuthException('Une erreur inconnue s\'est produite.');
    }
  }

  // Récupère les infos de l'utilisateur depuis Firestore
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (_) {
      throw AuthException('Impossible de récupérer les données utilisateur.');
    }
  }

  // Déconnexion simple
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Récupère le user actuel (FirebaseAuth)
  User? get currentUser => _auth.currentUser;
}

// Exception personnalisée pour gestion dans le provider
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
