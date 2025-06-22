import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/class_model.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String schoolId;

  ClassService(this.schoolId);

  // Expose la collection classes en public (pratique pour le stream)
  CollectionReference get ref =>
      _firestore.collection('schools').doc(schoolId).collection('classes');

  Future<List<Class>> getAll() async {
    final snapshot = await ref.orderBy('name').get();
    return snapshot.docs
        .map((doc) => Class.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Ajout qui retourne l'ID du document créé
  Future<String> addWithIdReturn(Class c) async {
    final docRef = await ref.add(c.toMap());
    return docRef.id;
  }

  Future<void> add(Class c) async {
    await ref.add(c.toMap());
  }

  Future<void> update(Class c) async {
    await ref.doc(c.id).update(c.toMap());
  }

  Future<void> delete(String id) async {
    await ref.doc(id).delete();
  }
}
