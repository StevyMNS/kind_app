import 'package:kind_app/domain/entities/message_entity.dart';
import 'package:kind_app/domain/repositories/message_repository.dart';

/// Use case : recevoir un message aléatoire d'un inconnu.
class ReceiveRandomMessage {
  final MessageRepository _repository;

  const ReceiveRandomMessage(this._repository);

  Future<MessageEntity?> call() => _repository.receiveRandomMessage();
}
