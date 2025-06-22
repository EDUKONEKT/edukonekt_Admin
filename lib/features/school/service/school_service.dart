import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/school.dart';

class SchoolService {
  final CollectionReference _schoolsRef = FirebaseFirestore.instance.collection('schools');

  Future<School?> getSchoolById(String id) async {
    final doc = await _schoolsRef.doc(id).get();
    if (!doc.exists) return null;
    return School.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<School?> getFirstSchool() async {
    final snapshot = await _schoolsRef.limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return School.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<String> createSchool(School school) async {
    final docRef = await _schoolsRef.add(school.toMap());
    return docRef.id;
  }

  Future<void> updateSchool(School school) async {
    await _schoolsRef.doc(school.id).update(school.toMap());
  }
}
