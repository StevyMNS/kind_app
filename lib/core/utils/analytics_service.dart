/// Abstraction pour les analytics — implémentation future possible.
abstract class AnalyticsService {
  void logEvent(String name, [Map<String, dynamic>? params]);
  void setUserId(String userId);
}

/// Implémentation no-op pour le développement.
class NoOpAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, [Map<String, dynamic>? params]) {
    // No-op : sera remplacé par une implémentation réelle.
  }

  @override
  void setUserId(String userId) {
    // No-op
  }
}
