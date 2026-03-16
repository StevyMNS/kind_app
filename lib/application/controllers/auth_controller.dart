import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kind_app/application/providers/repository_providers.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/domain/entities/user_entity.dart';

/// État d'authentification.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserEntity?>(AuthController.new);

/// Controller d'authentification avec auto-login silencieux.
class AuthController extends AsyncNotifier<UserEntity?> {
  @override
  FutureOr<UserEntity?> build() async {
    // Auto-login silencieux au démarrage
    try {
      final repo = ref.read(authRepositoryProvider);
      final isSignedIn = await repo.isSignedIn();
      if (isSignedIn) {
        final user = await repo.getCurrentUser();
        if (user != null) {
          AppLogger.info('Auto-login réussi: ${user.id}', 'AUTH');
          return user;
        }
      }
      // Connexion anonyme automatique
      final user = await repo.signInAnonymously();
      AppLogger.info('Nouvelle connexion anonyme: ${user.id}', 'AUTH');
      return user;
    } catch (e, st) {
      AppLogger.error('Échec auto-login', e, st);
      rethrow;
    }
  }

  /// Déconnexion.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      // Reconnexion anonyme après logout
      return repo.signInAnonymously();
    });
  }

  /// Force un re-login.
  Future<void> refresh() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
