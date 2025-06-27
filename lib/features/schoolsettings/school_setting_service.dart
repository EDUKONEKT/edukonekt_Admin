import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/school_setting_model.dart';

class SchoolSettingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String schoolId;

  SchoolSettingService(this.schoolId);

  /// Référence vers `schools/{schoolId}/settings/main`
  DocumentReference get ref => _firestore
      .collection('schools')
      .doc(schoolId)
      .collection('settings')
      .doc('main');

  /// Récupère le document une seule fois (offline-first implicite)
  Future<SchoolSetting?> getOnce() async {
    final snapshot = await ref.get();
    if (!snapshot.exists) return null;
    return SchoolSetting.fromFirestore(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }

  /// Sauvegarde avec fusion
  Future<void> update(SchoolSetting setting) async {
    await ref.set(setting.toFirestore(), SetOptions(merge: true));
  }

  /// Supprime complètement la configuration
  Future<void> delete() async {
    await ref.delete();
  }

  /// Stream temps réel
  Stream<SchoolSetting?> watch() {
    return ref.snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return SchoolSetting.fromFirestore(
        snapshot.data() as Map<String, dynamic>,
        snapshot.id,
      );
    });
  }
}
