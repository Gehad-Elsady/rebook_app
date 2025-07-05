import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentType {
  bankAccount,
  vodafoneCash,
  instapay,
}

class PaymentMethod {
  final String? id;
  final PaymentType type;
  final String accountName;
  final String accountNumber;
  final bool isDefault;
  final DateTime createdAt;

  PaymentMethod({
    this.id,
    required this.type,
    required this.accountName,
    required this.accountNumber,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from Firestore document to PaymentMethod
  factory PaymentMethod.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return PaymentMethod(
      id: snapshot.id,
      type: PaymentType.values[data['type'] as int],
      accountName: data['accountName'] as String,
      accountNumber: data['accountNumber'] as String,
      isDefault: data['isDefault'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert PaymentMethod to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.index,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a copy with some updated fields
  PaymentMethod copyWith({
    String? id,
    PaymentType? type,
    String? accountName,
    String? accountNumber,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
