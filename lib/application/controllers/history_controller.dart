import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/usecase_providers.dart';
import 'package:kind_app/core/constants/app_constants.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/domain/entities/message_entity.dart';
import 'package:translator/translator.dart';

/// État de l'historique avec pagination.
class HistoryState {
  final List<MessageEntity> sentMessages;
  final List<MessageEntity> receivedMessages;
  final bool hasMoreSent;
  final bool hasMoreReceived;
  final bool isLoadingMore;

  const HistoryState({
    this.sentMessages = const [],
    this.receivedMessages = const [],
    this.hasMoreSent = true,
    this.hasMoreReceived = true,
    this.isLoadingMore = false,
  });

  HistoryState copyWith({
    List<MessageEntity>? sentMessages,
    List<MessageEntity>? receivedMessages,
    bool? hasMoreSent,
    bool? hasMoreReceived,
    bool? isLoadingMore,
  }) {
    return HistoryState(
      sentMessages: sentMessages ?? this.sentMessages,
      receivedMessages: receivedMessages ?? this.receivedMessages,
      hasMoreSent: hasMoreSent ?? this.hasMoreSent,
      hasMoreReceived: hasMoreReceived ?? this.hasMoreReceived,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Provider de l'historique.
final historyControllerProvider =
    AsyncNotifierProvider<HistoryController, HistoryState>(
  HistoryController.new,
);

/// Controller pour l'historique des messages avec pagination.
class HistoryController extends AsyncNotifier<HistoryState> {
  @override
  FutureOr<HistoryState> build() async {
    try {
      final useCase = ref.read(getMessageHistoryUseCaseProvider);

      final sent = await useCase.sentMessages(
        offset: 0,
        limit: AppConstants.pageSize,
      );
      final rawReceived = await useCase.receivedMessages(
        offset: 0,
        limit: AppConstants.pageSize,
      );

      // Traduire les messages reçus
      final received = await _translateMessages(rawReceived);

      return HistoryState(
        sentMessages: sent,
        receivedMessages: received,
        hasMoreSent: sent.length >= AppConstants.pageSize,
        hasMoreReceived: received.length >= AppConstants.pageSize,
      );
    } catch (e, st) {
      AppLogger.error('Erreur chargement historique', e, st);
      rethrow;
    }
  }

  /// Traduit une liste de messages reçus vers la locale courante.
  Future<List<MessageEntity>> _translateMessages(
    List<MessageEntity> messages,
  ) async {
    if (messages.isEmpty) return messages;

    final translator = GoogleTranslator();
    final translatedMessages = <MessageEntity>[];

    for (final msg in messages) {
      try {
        final translation = await translator.translate(msg.content);

        translatedMessages.add(
          MessageEntity(
            id: msg.id,
            senderId: msg.senderId,
            content: translation.text,
            createdAt: msg.createdAt,
            senderCountryCode: msg.senderCountryCode,
            senderCountryEmoji: msg.senderCountryEmoji,
          ),
        );
      } catch (e) {
        AppLogger.error('Erreur de traduction pour le message ${msg.id}: $e');
        translatedMessages.add(msg);
      }
    }

    return translatedMessages;
  }

  /// Charge plus de messages envoyés.
  Future<void> loadMoreSent() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMoreSent || current.isLoadingMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final useCase = ref.read(getMessageHistoryUseCaseProvider);
      final moreSent = await useCase.sentMessages(
        offset: current.sentMessages.length,
        limit: AppConstants.pageSize,
      );

      state = AsyncData(
        current.copyWith(
          sentMessages: [...current.sentMessages, ...moreSent],
          hasMoreSent: moreSent.length >= AppConstants.pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.error('Erreur loadMoreSent', e, st);
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  /// Charge plus de messages reçus.
  Future<void> loadMoreReceived() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMoreReceived || current.isLoadingMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final useCase = ref.read(getMessageHistoryUseCaseProvider);
      final rawMoreReceived = await useCase.receivedMessages(
        offset: current.receivedMessages.length,
        limit: AppConstants.pageSize,
      );

      // Traduire le nouveau lot
      final moreReceived = await _translateMessages(rawMoreReceived);

      state = AsyncData(
        current.copyWith(
          receivedMessages: [...current.receivedMessages, ...moreReceived],
          hasMoreReceived: rawMoreReceived.length >= AppConstants.pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.error('Erreur loadMoreReceived', e, st);
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  /// Pull to refresh.
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
