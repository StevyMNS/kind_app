import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/datasource_providers.dart';
import 'package:kind_app/domain/repositories/auth_repository.dart';
import 'package:kind_app/domain/repositories/message_repository.dart';
import 'package:kind_app/infrastructure/repositories/auth_repository_impl.dart';
import 'package:kind_app/infrastructure/repositories/message_repository_impl.dart';

/// Provider pour le repository d'authentification.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

/// Provider pour le repository de messages.
final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final datasource = ref.watch(messageRemoteDatasourceProvider);
  return MessageRepositoryImpl(datasource);
});
