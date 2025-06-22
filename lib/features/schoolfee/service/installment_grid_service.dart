import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/installment_grid.dart';

class InstallmentGridService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String schoolId;

  late final CollectionReference _gridsRef;

  InstallmentGridService(this.schoolId) {
    _gridsRef = _firestore
        .collection('schools')
        .doc(schoolId)
        .collection('installment_grids');
  }

  Future<void> addGrid(InstallmentGrid grid) async {
    await _gridsRef.add(grid.toMap());
  }

  Future<void> deleteGrid(String id) async {
    await _gridsRef.doc(id).delete();
  }

  Future<List<InstallmentGrid>> getAllGrids() async {
    final snapshot = await _gridsRef.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => InstallmentGrid.fromDoc(doc)).toList();
  }

  Future<void> updateGrid(InstallmentGrid grid) async {
    await _gridsRef.doc(grid.id).update(grid.toMap());
  }

  Future<void> addGridAndLinkToSchool(InstallmentGrid grid) async {
  final docRef = await _gridsRef.add(grid.toMap()); // crée la grille, récupère l'ID
  final gridId = docRef.id;

  final schoolDocRef = _firestore.collection('schools').doc(schoolId);

  await schoolDocRef.update({
    'installmentGridIds': FieldValue.arrayUnion([gridId])
  });
}

Future<List<InstallmentGrid>> getGridsFromSchoolRef(String schoolId) async {
    final doc = await _firestore.collection('schools').doc(schoolId).get();

    if (!doc.exists) throw Exception("École introuvable");

    List<InstallmentGrid> grids = [];
    
 final snapshot = await _firestore
  .collection('schools')
  .doc(schoolId)
  .collection('installment_grids')
  .get();
 grids = snapshot.docs.map((doc) => InstallmentGrid.fromDoc(doc)).toList();

    
    return grids;
  }
}