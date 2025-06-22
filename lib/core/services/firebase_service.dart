import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<void> enableOfflinePersistence() async {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  }
}
// TODO Implement this library.