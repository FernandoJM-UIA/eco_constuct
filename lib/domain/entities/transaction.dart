import 'package:equatable/equatable.dart';

enum TransactionStatus {
  pending,
  completed,
  cancelled,
}

class Transaction extends Equatable {
  final String id;
  final String buyerId;
  final String sellerId;
  final String materialId;
  final double amount;
  final TransactionStatus status;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.materialId,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  Transaction copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
    String? materialId,
    double? amount,
    TransactionStatus? status,
    DateTime? timestamp,
  }) {
    return Transaction(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      materialId: materialId ?? this.materialId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        buyerId,
        sellerId,
        materialId,
        amount,
        status,
        timestamp,
      ];
}
