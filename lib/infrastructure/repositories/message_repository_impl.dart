import 'package:kind_app/core/error/exceptions.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/domain/entities/message_entity.dart';
import 'package:kind_app/domain/repositories/message_repository.dart';
import 'package:kind_app/infrastructure/datasources/message_remote_datasource.dart';

/// Implémentation du repository de messages.
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDatasource _datasource;

  const MessageRepositoryImpl(this._datasource);

  @override
  Future<MessageEntity> sendMessage(String content) async {
    try {
      final model = await _datasource.sendMessage(content);
      return model.toEntity();
    } on ServerException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('MessageRepositoryImpl.sendMessage', e, st);
      throw ServerException('Erreur envoi message: ${e.toString()}');
    }
  }

  @override
  Future<MessageEntity?> receiveRandomMessage() async {
    try {
      final model = await _datasource.receiveRandomMessage();
      return model?.toEntity();
    } on ServerException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('MessageRepositoryImpl.receiveRandomMessage', e, st);
      throw ServerException('Erreur réception message: ${e.toString()}');
    }
  }

  @override
  Future<List<MessageEntity>> getSentMessages({
    required int offset,
    required int limit,
  }) async {
    try {
      final models = await _datasource.getSentMessages(
        offset: offset,
        limit: limit,
      );
      return models.map((m) => m.toEntity()).toList();
    } on ServerException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('MessageRepositoryImpl.getSentMessages', e, st);
      throw ServerException('Erreur historique envoyés: ${e.toString()}');
    }
  }

  @override
  Future<List<MessageEntity>> getReceivedMessages({
    required int offset,
    required int limit,
  }) async {
    try {
      final models = await _datasource.getReceivedMessages(
        offset: offset,
        limit: limit,
      );
      return models.map((m) => m.toEntity()).toList();
    } on ServerException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('MessageRepositoryImpl.getReceivedMessages', e, st);
      throw ServerException('Erreur historique reçus: ${e.toString()}');
    }
  }
}
