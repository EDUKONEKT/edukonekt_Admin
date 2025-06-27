import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String authUid;
  final String role;
  final String email;
  final String username;
  final bool passwordTemporaire;
  final bool requiresAccount;
  final String? temporaryPassword; // ← utilisé uniquement en mémoire (jamais stocké)
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.authUid,
    required this.role,
    required this.email,
    required this.username,
    required this.passwordTemporaire,
    required this.requiresAccount,
    required this.temporaryPassword,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

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
      requiresAccount: data['requiresAccount'] ?? false,
      temporaryPassword: null, // ← jamais lu depuis Firestore
      isSynced: data['isSynced'] ?? false,
      createdAt: createdTs?.toDate() ?? DateTime.now(),
      updatedAt: updatedTs?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authUid': authUid,
      'role': role,
      'email': email,
      'username': username,
      'passwordTemporaire': passwordTemporaire,
      'requiresAccount': requiresAccount,
      // ❌ 'temporaryPassword': ... (jamais stocké)
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  User copyWith({
    String? id,
    String? authUid,
    String? role,
    String? email,
    String? username,
    bool? passwordTemporaire,
    bool? requiresAccount,
    String? temporaryPassword,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      authUid: authUid ?? this.authUid,
      role: role ?? this.role,
      email: email ?? this.email,
      username: username ?? this.username,
      passwordTemporaire: passwordTemporaire ?? this.passwordTemporaire,
      requiresAccount: requiresAccount ?? this.requiresAccount,
      temporaryPassword: temporaryPassword ?? this.temporaryPassword,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Utilitaire : purger temporairement le mot de passe après synchro
  User purgeTemporaryPassword() => copyWith(temporaryPassword: null);
}
