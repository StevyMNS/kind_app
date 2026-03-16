import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/usecase_providers.dart';
import 'package:kind_app/core/services/daily_limit_service.dart';
import 'package:kind_app/core/services/stats_service.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/core/utils/validators.dart';
import 'package:kind_app/domain/entities/message_entity.dart';

/// État pour l'envoi de message.
/// null = prêt, MessageEntity = envoyé avec succès.
final sendMessageControllerProvider =
    AsyncNotifierProvider<SendMessageController, MessageEntity?>(
      SendMessageController.new,
    );

/// Controller pour l'envoi de messages bienveillants.
class SendMessageController extends AsyncNotifier<MessageEntity?> {
  @override
  FutureOr<MessageEntity?> build() => null;

  /// Envoie un message après validation.
  Future<bool> send(String content) async {
    // Validation locale
    final validationError = Validators.validateMessage(content);
    if (validationError != null) {
      state = AsyncError(validationError, StackTrace.current);
      return false;
    }

    state = const AsyncValue.loading();

    // Vérifier la limite quotidienne
    final limitService = ref.read(dailyLimitServiceProvider);
    if (!limitService.canSendToday()) {
      state = AsyncError(
        'Vous avez déjà envoyé un message aujourd\'hui. Revenez demain !',
        StackTrace.current,
      );
      return false;
    }

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(sendMessageUseCaseProvider);
      final message = await useCase(content.trim());

      // Succès -> Marquer dans SharedPreferences + incrémenter le streak
      await limitService.markAsSentToday();
      await ref.read(statsServiceProvider).recordActivity();

      AppLogger.info('Message envoyé: ${message.id}', 'SEND');
      return message;
    });

    return !state.hasError;
  }

  /// Réinitialise l'état.
  void reset() {
    state = const AsyncData(null);
  }
}
