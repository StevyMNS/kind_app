import 'package:kind_app/core/constants/app_constants.dart';
import 'package:kind_app/core/error/exceptions.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/infrastructure/models/delivery_model.dart';
import 'package:kind_app/infrastructure/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Source de données distante pour les messages via Supabase.
class MessageRemoteDatasource {
  final SupabaseClient _client;

  const MessageRemoteDatasource(this._client);

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AppAuthException('Utilisateur non connecté.');
    }
    return user.id;
  }

  /// Envoie un message.
  Future<MessageModel> sendMessage(String content) async {
    try {
      final response = await _client
          .from(AppConstants.messagesTable)
          .insert({'sender_id': _currentUserId, 'content': content})
          .select()
          .single();

      AppLogger.info('Message envoyé avec succès', 'MESSAGE');
      return MessageModel.fromJson(response);
    } catch (e, st) {
      AppLogger.error('Erreur sendMessage', e, st);
      throw ServerException(
        'Impossible d\'envoyer le message: ${e.toString()}',
      );
    }
  }

  /// Récupère un message aléatoire non encore reçu par l'utilisateur courant.
  /// Exclut les messages de l'utilisateur et les messages déjà reçus.
  Future<MessageModel?> receiveRandomMessage() async {
    try {
      final userId = _currentUserId;

      // Appelle une RPC Supabase pour le matching aléatoire
      final response = await _client.rpc(
        'get_random_unread_message',
        params: {'user_id_param': userId},
      );

      if (response == null || (response is List && response.isEmpty)) {
        AppLogger.info('Aucun message disponible', 'MESSAGE');
        return null;
      }

      final data = response is List ? response.first : response;
      final message = MessageModel.fromJson(data as Map<String, dynamic>);

      // Créer la livraison
      await _client.from(AppConstants.deliveriesTable).insert({
        'message_id': message.id,
        'receiver_id': userId,
      });

      AppLogger.info('Message reçu: ${message.id}', 'MESSAGE');
      return message;
    } catch (e, st) {
      AppLogger.error('Erreur receiveRandomMessage', e, st);
      throw ServerException(
        'Impossible de recevoir un message: ${e.toString()}',
      );
    }
  }

  /// Récupère les messages envoyés par l'utilisateur (paginés).
  Future<List<MessageModel>> getSentMessages({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _client
          .from(AppConstants.messagesTable)
          .select()
          .eq('sender_id', _currentUserId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      AppLogger.error('Erreur getSentMessages', e, st);
      throw ServerException(
        'Impossible de récupérer les messages envoyés: ${e.toString()}',
      );
    }
  }

  /// Récupère les messages reçus par l'utilisateur (paginés via deliveries).
  Future<List<MessageModel>> getReceivedMessages({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _client
          .from(AppConstants.deliveriesTable)
          .select('message_id, delivered_at, messages(*)')
          .eq('receiver_id', _currentUserId)
          .order('delivered_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((json) {
        final messageJson = json['messages'] as Map<String, dynamic>;
        return MessageModel.fromJson(messageJson);
      }).toList();
    } catch (e, st) {
      AppLogger.error('Erreur getReceivedMessages', e, st);
      throw ServerException(
        'Impossible de récupérer les messages reçus: ${e.toString()}',
      );
    }
  }

  /// Récupère les IDs de livraisons pour vérification.
  Future<List<DeliveryModel>> getDeliveries({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _client
          .from(AppConstants.deliveriesTable)
          .select()
          .eq('receiver_id', _currentUserId)
          .order('delivered_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => DeliveryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      AppLogger.error('Erreur getDeliveries', e, st);
      throw ServerException(
        'Impossible de récupérer les livraisons: ${e.toString()}',
      );
    }
  }
}
