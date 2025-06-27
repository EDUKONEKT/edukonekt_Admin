import '../../../core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:logger/logger.dart';

final Logger _log = Logger();

class UserService {
  UserService();

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'users';

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(_collection);

  /// 👤 Getter Firebase Auth (public)
  fb.FirebaseAuth get auth => _auth;

  /// 🔍 Récupérer un utilisateur par ID
  Future<User?> getUserById(String id) async {
    try {
      final doc = await _col.doc(id).get();
      if (doc.exists) {
        return User.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e, s) {
      _log.e('getUserById error', error: e, stackTrace: s);
      return null;
    }
  }

  /// ➕ Création complète Auth + Firestore
  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    required String username,
    required String schoolId,
  }) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;
      final now = FieldValue.serverTimestamp();

      final docRef = _col.doc();

      final user = {
        'authUid': uid,
        'role': role,
        'email': email,
        'username': username,
        'passwordTemporaire': true,
        'schoolId': schoolId,
        'isSynced': false,
        'createdAt': now,
        'updatedAt': now,
      };

      await docRef.set(user);
    } catch (e, s) {
      _log.e('createUser', error: e, stackTrace: s);
      rethrow;
    }
  }
  
  
  /// ✏️ Mise à jour
  Future<void> updateUser(User user) async {
    try {
      await _col.doc(user.id).update({
        ...user.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isSynced': false,
      });
    } catch (e, s) {
      _log.e('updateUser', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// ❌ Suppression
  Future<void> deleteUser(String id) async {
    try {
      await _col.doc(id).delete();
    } catch (e, s) {
      _log.e('deleteUser', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// 🔁 Stream
  Stream<List<User>> watchUsers() {
    return _col.snapshots(includeMetadataChanges: true).map(
      (snap) => snap.docs.map((doc) {
        final user = User.fromFirestore(doc.data(), doc.id);
        return user.copyWith(isSynced: !doc.metadata.hasPendingWrites);
      }).toList(),
    );
  }

  /// 📥 Cache local
  Future<List<User>> getUsersOnce() async {
    final snap = await _col.get(const GetOptions(source: Source.cache));
    return snap.docs
        .map((doc) => User.fromFirestore(doc.data(), doc.id))
        .toList();
  }
  
  Future<User?> getUserByEmail(String email) async {
  try {
    final query = await _col
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return User.fromFirestore(doc.data(), doc.id);
    }

    return null;
  } catch (e) {
    _log.e('Erreur dans getUserByEmail pour $email', error: e);
    return null;
  }
}

  /// ➕ Ajout direct Firestore
  Future<void> addUserToFirestore(User user) async {
    try {
      await _db.collection('users').doc(user.id).set({
        ...user.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isSynced': false,
      });
    } on FirebaseException catch (e, s) {
      _log.e('addUserToFirestore FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('addUserToFirestore Exception', error: e, stackTrace: s);
      rethrow;
    }
  }
}
