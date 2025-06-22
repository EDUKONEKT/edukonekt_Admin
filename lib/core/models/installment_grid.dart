import 'package:cloud_firestore/cloud_firestore.dart';
import 'installment.dart';

class InstallmentGrid {
  final String id;
  final String name;
  final String classId;
  final double amountTot;
  final List<Installment> installments;
  final DateTime createdAt;
  final DateTime updatedAt;

  InstallmentGrid({
    required this.id,
    required this.name,
    required this.classId,
    required this.amountTot,
    required this.installments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstallmentGrid.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InstallmentGrid(
      id: doc.id,
      name: data['name'],
      classId: data['classId'],
      amountTot: data['amountTot'],
      installments: (data['installments'] as List)
          .map((e) => Installment.fromMap(e))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'classId': classId,
      'amountTot': amountTot,
      'installments': installments.map((e) => e.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
