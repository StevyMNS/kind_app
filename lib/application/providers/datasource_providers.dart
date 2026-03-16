import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/supabase_providers.dart';
import 'package:kind_app/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:kind_app/infrastructure/datasources/message_remote_datasource.dart';

/// Provider pour la datasource d'authentification.
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDatasource(client);
});

/// Provider pour la datasource de messages.
final messageRemoteDatasourceProvider = Provider<MessageRemoteDatasource>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);
  return MessageRemoteDatasource(client);
});
