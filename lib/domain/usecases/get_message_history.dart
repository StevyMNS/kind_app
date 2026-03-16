import 'package:kind_app/domain/entities/message_entity.dart';
import 'package:kind_app/domain/repositories/message_repository.dart';

/// Use case : récupérer l'historique des messages.
class GetMessageHistory {
  final MessageRepository _repository;

  const GetMessageHistory(this._repository);

  Future<List<MessageEntity>> sentMessages({
    required int offset,
    required int limit,
  }) => _repository.getSentMessages(offset: offset, limit: limit);

  Future<List<MessageEntity>> receivedMessages({
    required int offset,
    required int limit,
  }) => _repository.getReceivedMessages(offset: offset, limit: limit);
}
