import '../../../core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:logger/logger.dart';


final Logger _log = Logger();

class UserService {
  UserService();

  final _auth = fb.FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _collection = 'users';

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(_collection);

  /// Création de l'utilisateur Firebase Auth + Firestore
  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    required String username,
    required String schoolId,
  }) async {
    try {
      // 1. Créer dans Firebase Auth
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;
      final now = FieldValue.serverTimestamp();

      // 2. Créer dans Firestore (collection users)
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

  Future<void> deleteUser(String id) async {
    try {
      await _col.doc(id).delete();
    } catch (e, s) {
      _log.e('deleteUser', error: e, stackTrace: s);
      rethrow;
    }
  }

  Stream<List<User>> watchUsers() {
    return _col.snapshots(includeMetadataChanges: true).map(
      (snap) => snap.docs.map((doc) {
        final user = User.fromFirestore(doc.data(), doc.id);
        return user.copyWith(isSynced: !doc.metadata.hasPendingWrites);
      }).toList(),
    );
  }

  Future<List<User>> getUsersOnce() async {
    final snap = await _col.get(const GetOptions(source: Source.cache));
    return snap.docs
        .map((doc) => User.fromFirestore(doc.data(), doc.id))
        .toList();
  }

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
