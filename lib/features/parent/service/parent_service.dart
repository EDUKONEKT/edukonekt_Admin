import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/parent_model.dart';
import 'dart:async';
import 'package:logger/logger.dart';


final Logger _log = Logger();

// -----------------------------------------------------------------------------
// ParentService
// -----------------------------------------------------------------------------
class ParentService {
  ParentService(this.schoolId) : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  final String schoolId;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('schools').doc(schoolId).collection('parents');

  // ----------------------------- CRUD ---------------------------------------

  Future<void> addParent(Parent p) async {
    try {
      await _col.doc(p.id).set({
        ...p.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isSynced': false,
      });
    } on FirebaseException catch (e, s) {
      _log.e('addParent FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('addParent Exception', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateParent(Parent p) async {
    try {
      await _col.doc(p.id).update({
        ...p.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isSynced': false,
      });
    } on FirebaseException catch (e, s) {
      _log.e('updateParent FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('updateParent Exception', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteParent(String id) async {
    try {
      await _col.doc(id).delete();
    } on FirebaseException catch (e, s) {
      _log.e('deleteParent FirebaseException', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      _log.e('deleteParent Exception', error: e, stackTrace: s);
      rethrow;
    }
  }

  // ----------------------------- STREAM -------------------------------------

  Stream<List<Parent>> watchParents() {
    return _col.orderBy('fatherfullName').snapshots(includeMetadataChanges: true).map(
      (query) => query.docs.map((d) {
        final data = d.data();
        final parent = Parent.fromFirestore(data, d.id);
        // Màj champ isSynced basé sur metadata
        return parent.copyWith(isSynced: !d.metadata.hasPendingWrites);
      }).toList(),
    );
  }

  /// Utilisé par le Preloader pour récupérer la liste une seule fois (cache inclus)
  Future<List<Parent>> getParentsOnce() async {
    final querySnap = await _col.get(const GetOptions(source: Source.cache));
    return querySnap.docs
        .map((d) => Parent.fromFirestore(d.data(), d.id))
        .toList();
  }

  // 🔍 Recherche d'un parent par numéro (pour éviter doublons)
Future<Parent?> findByPhone(String phone) async {
  try {
    final query = await _col.where('phone', isEqualTo: phone).limit(1).get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return Parent.fromFirestore(doc.data(), doc.id);
    }
    return null;
  } catch (e, s) {
    _log.e('findByPhone error', error: e, stackTrace: s);
    return null;
  }
}

// 🔤 Recherche par nom de parent (autocomplete)
Future<List<Parent>> searchByNamePrefix(String query) async {
  try {
    final snapshot = await _col
        .orderBy('fatherfullName')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => Parent.fromFirestore(doc.data(), doc.id))
        .toList();
  } catch (e, s) {
    _log.e('searchByNamePrefix error', error: e, stackTrace: s);
    return [];
  }
}

  
}