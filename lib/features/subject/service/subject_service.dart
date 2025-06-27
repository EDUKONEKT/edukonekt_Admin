import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../../core/models/subject_model.dart';

class SubjectService {
  final Logger _log = Logger();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String schoolId) =>
      _db.collection('schools').doc(schoolId).collection('subjects');

  CollectionReference<Map<String, dynamic>> ref(String schoolId) => _col(schoolId);

  Stream<List<Subject>> watchSubjects(String schoolId) {
    return _col(schoolId).snapshots(includeMetadataChanges: true).map(
      (snap) => snap.docs.map((doc) {
        final subject = Subject.fromFirestore(doc.data(), doc.id);
        return subject.copyWith(isSynced: !doc.metadata.hasPendingWrites);
      }).toList(),
    );
  }

  Future<List<Subject>> getSubjectsOnce(String schoolId) async {
    try {
      final snap = await _col(schoolId).get(); // 🔄 pas de Source.cache forcé
      return snap.docs.map((doc) => Subject.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e, s) {
      _log.e('getSubjectsOnce error', error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> addSubject(String schoolId, Subject s) async {
    try {
      _log.i('addSubject: ${s.name} (${s.id})');
      await _col(schoolId).doc(s.id).set({
        ...s.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, s) {
      _log.e('addSubject error', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateSubject(String schoolId, Subject s) async {
    try {
      _log.i('updateSubject: ${s.name} (${s.id})');
      await _col(schoolId).doc(s.id).update({
        ...s.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, s) {
      _log.e('updateSubject error', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteSubject(String schoolId, String id) async {
    try {
      _log.i('deleteSubject: $id');
      await _col(schoolId).doc(id).delete();
    } catch (e, s) {
      _log.e('deleteSubject error', error: e, stackTrace: s);
      rethrow;
    }
  }

  Subject? getByName(List<Subject> list, String name) {
    try {
      return list.firstWhere((s) => s.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  Subject? getByCode(List<Subject> list, String code) {
    try {
      return list.firstWhere((s) => s.code.toLowerCase() == code.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  List<Subject> filterByKeyword(List<Subject> list, String keyword) {
    final lower = keyword.toLowerCase();
    return list.where((s) =>
      s.name.toLowerCase().contains(lower) ||
      s.code.toLowerCase().contains(lower) ||
      s.description.toLowerCase().contains(lower)).toList();
  }
}
