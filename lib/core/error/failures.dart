/// Classe scellée représentant les échecs applicatifs.
sealed class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => 'Failure: $message';
}

/// Échec lié au serveur / réseau.
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.stackTrace]);
}

/// Échec lié à l'authentification.
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.stackTrace]);
}

/// Échec lié au cache local.
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.stackTrace]);
}

/// Échec de validation des données.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.stackTrace]);
}

/// Échec inconnu.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Une erreur inattendue est survenue.']);
}
