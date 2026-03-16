/// Constantes globales de l'application.
class AppConstants {
  AppConstants._();

  /// Nom de l'application.
  static const String appName = 'One Kind Message';

  /// Version de l'application.
  static const String appVersion = '1.0.0';

  /// Longueur maximale d'un message.
  static const int messageMaxLength = 200;

  /// Nombre d'éléments par page pour la pagination.
  static const int pageSize = 20;

  /// Timeout réseau en secondes.
  static const int networkTimeoutSeconds = 15;

  /// Phrases contemplatives pour l'écran d'accueil.
  static const List<String> contemplativePhrases = [
    'Un mot peut changer une journée.',
    'La bienveillance voyage en silence.',
    'Quelqu\'un, quelque part, a besoin de vos mots.',
    'Chaque message porte une lumière.',
    'Offrez un sourire invisible au monde.',
    'Votre douceur peut toucher un cœur.',
  ];

  /// Tables Supabase.
  static const String usersTable = 'users';
  static const String messagesTable = 'messages';
  static const String deliveriesTable = 'deliveries';
}
