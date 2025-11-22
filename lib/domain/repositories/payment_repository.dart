import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/transaction.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction);
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  Future<Either<Failure, List<Transaction>>> getUserTransactions(String userId);
  Future<Either<Failure, void>> updateTransactionStatus(String id, TransactionStatus status);
}
