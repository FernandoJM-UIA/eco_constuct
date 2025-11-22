import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.buyerId,
    required super.sellerId,
    required super.materialId,
    required super.amount,
    required super.status,
    required super.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      buyerId: json['buyerId'],
      sellerId: json['sellerId'],
      materialId: json['materialId'],
      amount: (json['amount'] as num).toDouble(),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'materialId': materialId,
      'amount': amount,
      'status': status.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      buyerId: transaction.buyerId,
      sellerId: transaction.sellerId,
      materialId: transaction.materialId,
      amount: transaction.amount,
      status: transaction.status,
      timestamp: transaction.timestamp,
    );
  }
}
