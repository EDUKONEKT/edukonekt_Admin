import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/absence_model.dart';

class AbsenceService {
  final String schoolId;
  late final CollectionReference _collection;

  AbsenceService({required this.schoolId}) {
    _collection = FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('absences');
  }

  CollectionReference get ref => _collection;

  Future<void> addAbsence(Absence absence) async {
    await _collection.doc(absence.id).set(
      absence.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateAbsence(Absence absence) async {
    await _collection.doc(absence.id).update(absence.toFirestore());
  }

  Future<void> deleteAbsence(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<Absence>> getAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => Absence.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Absence?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return Absence.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (_) {
      return null;
    }
  }

  Stream<List<Absence>> watch() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Absence.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  Future<void> sync(List<Absence> unsynced) async {
    for (final absence in unsynced) {
      await _collection.doc(absence.id).set(
        absence.copyWith(isSynced: true).toFirestore(),
        SetOptions(merge: true),
      );
    }
  }

  Future<List<Absence>> getByStudent(String studentId) async {
    try {
      final snapshot = await _collection.where('studentId', isEqualTo: studentId).get();
      return snapshot.docs
          .map((doc) => Absence.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Absence>> getByDate(DateTime date) async {
    try {
      final snapshot = await _collection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
          .where('date', isLessThan: Timestamp.fromDate(date.add(const Duration(days: 1))))
          .get();
      return snapshot.docs
          .map((doc) => Absence.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Absence>> getByJustification(bool isJustified) async {
    try {
      final snapshot = await _collection.where('isJustified', isEqualTo: isJustified).get();
      return snapshot.docs
          .map((doc) => Absence.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
