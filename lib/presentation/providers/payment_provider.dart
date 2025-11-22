import 'package:flutter/foundation.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository repository;

  bool _isProcessing = false;
  String? _errorMessage;

  PaymentProvider(this.repository);

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  Future<bool> processPayment(Transaction transaction) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.createTransaction(transaction);
    _isProcessing = false;
    
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (txn) {
        notifyListeners();
        return true;
      },
    );
  }
}
