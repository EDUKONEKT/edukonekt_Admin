import 'package:cloud_firestore/cloud_firestore.dart';

class Installment {
  final int order;
  final double amount;
  final DateTime dueDate;

  Installment({
    required this.order,
    required this.amount,
    required this.dueDate,
  });

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment(
      order: map['order'],
      amount: (map['amount'] as num).toDouble(),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'amount': amount,
      'dueDate': dueDate,
    };
  }
}
