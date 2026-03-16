import 'package:kind_app/domain/entities/user_entity.dart';

/// Interface abstraite pour le repository d'authentification.
abstract class AuthRepository {
  /// Connecte l'utilisateur anonymement.
  Future<UserEntity> signInAnonymously();

  /// Vérifie si l'utilisateur est connecté.
  Future<bool> isSignedIn();

  /// Récupère l'utilisateur courant.
  Future<UserEntity?> getCurrentUser();

  /// Déconnecte l'utilisateur.
  Future<void> signOut();
}
