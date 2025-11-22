import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/mock_data_source.dart';
import '../models/transaction_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final MockDataSource dataSource;

  PaymentRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final result = await dataSource.createTransaction(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    // Not implemented in mock
    return const Left(CacheFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<Transaction>>> getUserTransactions(String userId) async {
    try {
      final transactions = await dataSource.getUserTransactions(userId);
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransactionStatus(String id, TransactionStatus status) async {
    // Not implemented in mock
    return const Right(null);
  }
}
