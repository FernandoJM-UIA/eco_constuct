import 'package:flutter/foundation.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/messaging_repository.dart';

class MessagingProvider extends ChangeNotifier {
  final MessagingRepository repository;

  List<Message> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  MessagingProvider(this.repository);

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadConversation(String otherUserId, String materialId) async {
    _isLoading = true;
    notifyListeners();

    final result = await repository.getConversation(otherUserId, materialId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (msgs) {
        _messages = msgs;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(Message message) async {
    final result = await repository.sendMessage(message);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _messages.add(message);
        notifyListeners();
      },
    );
  }
}
