import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String authUid;
  String role;
  String email;
  String username;
  bool passwordTemporaire;
  bool isSynced;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.authUid,
    required this.role,
    required this.email,
    required this.username,
    required this.passwordTemporaire,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a User object from a Firestore Map
factory User.fromFirestore(Map<String, dynamic> data, String id) {
  final Timestamp? createdTs = data['createdAt'] as Timestamp?;
  final Timestamp? updatedTs = data['updatedAt'] as Timestamp?;

  return User(
    id: id,
    authUid: data['authUid'] ?? '',
    role: data['role'] ?? '',
    email: data['email'] ?? '',
    username: data['username'] ?? '',
    passwordTemporaire: data['passwordTemporaire'] ?? false,
    isSynced: data['isSynced'] ?? false,
    createdAt: createdTs?.toDate() ?? DateTime.now(),
    updatedAt: updatedTs?.toDate() ?? DateTime.now(),
  );
}


  // Method to convert a User object to a Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'authUid': authUid,
      'role': role,
      'email': email,
      'username': username,
      'passwordTemporaire': passwordTemporaire,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

User copyWith({bool? isSynced}) => User(
        id: id,
        authUid: authUid,
        role: role,
        email: email,
        username: username,
        passwordTemporaire: passwordTemporaire,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

}

