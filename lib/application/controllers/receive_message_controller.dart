import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/usecase_providers.dart';
import 'package:kind_app/core/services/daily_limit_service.dart';
import 'package:kind_app/core/services/stats_service.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/domain/entities/message_entity.dart';

/// État pour la réception de message.
/// null = pas encore de message reçu.
final receiveMessageControllerProvider =
    AsyncNotifierProvider<ReceiveMessageController, MessageEntity?>(
      ReceiveMessageController.new,
    );

/// Controller pour la réception de messages aléatoires.
class ReceiveMessageController extends AsyncNotifier<MessageEntity?> {
  @override
  FutureOr<MessageEntity?> build() => null;

  /// Reçoit un message aléatoire d'un inconnu.
  Future<void> receiveMessage() async {
    state = const AsyncValue.loading();

    // 1. Vérifier la limite quotidienne
    final limitService = ref.read(dailyLimitServiceProvider);
    if (!limitService.canReceiveToday()) {
      state = AsyncValue.error(
        'Vous avez déjà reçu votre message pour aujourd\'hui. Revenez demain pour un nouveau mot doux !',
        StackTrace.current,
      );
      return;
    }

    // 2. Récupérer un message aléatoire
    final result = await AsyncValue.guard(() async {
      final useCase = ref.read(receiveRandomMessageUseCaseProvider);
      final message = await useCase();
      if (message != null) {
        AppLogger.info('Message reçu: ${message.id}', 'RECEIVE');
      } else {
        AppLogger.info('Aucun message disponible', 'RECEIVE');
      }
      return message;
    });

    // 3. Mettre à jour l'état et enregistrer l'activité si succès
    if (result.hasValue) {
      // Enregistrer la réception et incrémenter le streak
      if (result.value != null) {
        await limitService.markAsReceivedToday();
        await ref.read(statsServiceProvider).recordActivity();
      }
      state = AsyncValue.data(result.value);
    } else if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
    }
  }

  /// Réinitialise l'état.
  void reset() {
    state = const AsyncData(null);
  }
}
