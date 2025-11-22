import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/message.dart';

abstract class MessagingRepository {
  Future<Either<Failure, List<Message>>> getConversation(String otherUserId, String materialId);
  Future<Either<Failure, void>> sendMessage(Message message);
  Future<Either<Failure, void>> markAsRead(String messageId);
}
