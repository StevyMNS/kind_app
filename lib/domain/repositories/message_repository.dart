import 'package:kind_app/domain/entities/message_entity.dart';

/// Interface abstraite pour le repository de messages.
abstract class MessageRepository {
  /// Envoie un message bienveillant.
  Future<MessageEntity> sendMessage(String content);

  /// Récupère un message aléatoire non encore reçu par l'utilisateur.
  Future<MessageEntity?> receiveRandomMessage();

  /// Récupère les messages envoyés par l'utilisateur (paginés).
  Future<List<MessageEntity>> getSentMessages({
    required int offset,
    required int limit,
  });

  /// Récupère les messages reçus par l'utilisateur (paginés).
  Future<List<MessageEntity>> getReceivedMessages({
    required int offset,
    required int limit,
  });
}
