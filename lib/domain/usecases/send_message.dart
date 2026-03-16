import 'package:kind_app/domain/entities/message_entity.dart';
import 'package:kind_app/domain/repositories/message_repository.dart';

/// Use case : envoyer un message bienveillant.
class SendMessage {
  final MessageRepository _repository;

  const SendMessage(this._repository);

  Future<MessageEntity> call(String content) =>
      _repository.sendMessage(content);
}
