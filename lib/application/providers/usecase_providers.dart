import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/repository_providers.dart';
import 'package:kind_app/domain/usecases/get_message_history.dart';
import 'package:kind_app/domain/usecases/receive_random_message.dart';
import 'package:kind_app/domain/usecases/send_message.dart';
import 'package:kind_app/domain/usecases/sign_in_anonymously.dart';

/// Provider pour le use case de connexion anonyme.
final signInAnonymouslyProvider = Provider<SignInAnonymously>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInAnonymously(repo);
});

/// Provider pour le use case d'envoi de message.
final sendMessageUseCaseProvider = Provider<SendMessage>((ref) {
  final repo = ref.watch(messageRepositoryProvider);
  return SendMessage(repo);
});

/// Provider pour le use case de réception aléatoire.
final receiveRandomMessageUseCaseProvider = Provider<ReceiveRandomMessage>((
  ref,
) {
  final repo = ref.watch(messageRepositoryProvider);
  return ReceiveRandomMessage(repo);
});

/// Provider pour le use case d'historique.
final getMessageHistoryUseCaseProvider = Provider<GetMessageHistory>((ref) {
  final repo = ref.watch(messageRepositoryProvider);
  return GetMessageHistory(repo);
});
