/// Exceptions custom de l'application.
library;

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Erreur serveur']);

  @override
  String toString() => 'ServerException: $message';
}

class AppAuthException implements Exception {
  final String message;
  const AppAuthException([this.message = 'Erreur d\'authentification']);

  @override
  String toString() => 'AppAuthException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Erreur de cache']);

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Erreur de validation']);

  @override
  String toString() => 'ValidationException: $message';
}

class NetworkTimeoutException implements Exception {
  final String message;
  const NetworkTimeoutException([
    this.message = 'La connexion a expiré. Vérifiez votre réseau.',
  ]);

  @override
  String toString() => 'NetworkTimeoutException: $message';
}
