import '../data/support_chat_repository.dart';
import '../domain/support_chat_message.dart';

class SupportChatService {
  SupportChatService({required SupportChatRepository repository})
    : _repository = repository;

  final SupportChatRepository _repository;

  Stream<List<SupportChatMessage>> watchConversation({int limit = 50}) {
    return _repository.watchMessages(limit: limit);
  }

  Future<void> sendUserMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }
    return _repository.sendUserMessage(trimmed);
  }
}
