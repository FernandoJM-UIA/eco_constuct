import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../datasources/mock_data_source.dart';
import '../models/message_model.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final MockDataSource dataSource;
  final AuthRepository authRepository;

  MessagingRepositoryImpl(this.dataSource, this.authRepository);

  @override
  Future<Either<Failure, List<Message>>> getConversation(String otherUserId, String materialId) async {
    try {
      final userResult = await authRepository.getCurrentUser();
      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          if (user == null) return const Left(AuthFailure('User not logged in'));
          final messages = await dataSource.getConversation(otherUserId, user.id, materialId);
          return Right(messages);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      final model = MessageModel.fromEntity(message);
      await dataSource.sendMessage(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    // Not implemented in mock
    return const Right(null);
  }
}
