import 'package:kind_app/core/error/exceptions.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Source de données distante pour l'authentification via Supabase.
class AuthRemoteDatasource {
  final SupabaseClient _client;

  const AuthRemoteDatasource(this._client);

  /// Connexion anonyme.
  Future<User> signInAnonymously() async {
    try {
      final response = await _client.auth.signInAnonymously();
      final user = response.user;
      if (user == null) {
        throw const AppAuthException('Échec de l\'authentification anonyme.');
      }
      AppLogger.info('Connexion anonyme réussie: ${user.id}', 'AUTH');

      // Créer l'entrée utilisateur dans la table users
      await _client.from('users').upsert({
        'id': user.id,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      return user;
    } on AppAuthException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('Erreur signInAnonymously', e, st);
      throw AppAuthException('Échec de la connexion: ${e.toString()}');
    }
  }

  /// Vérifie si un utilisateur est connecté.
  bool get isSignedIn => _client.auth.currentUser != null;

  /// Récupère l'utilisateur courant.
  User? get currentUser => _client.auth.currentUser;

  /// Déconnexion.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      AppLogger.info('Déconnexion réussie', 'AUTH');
    } catch (e, st) {
      AppLogger.error('Erreur signOut', e, st);
      throw AppAuthException('Échec de la déconnexion: ${e.toString()}');
    }
  }
}
