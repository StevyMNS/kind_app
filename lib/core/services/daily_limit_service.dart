import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dailyLimitServiceProvider = Provider<DailyLimitService>((ref) {
  throw UnimplementedError('Initialisé dans le main');
});

/// Service gérant la limite d'un envoi et d'une réception par jour localement.
class DailyLimitService {
  final SharedPreferences _prefs;

  static const String _lastSentKey = 'last_sent_date';
  static const String _lastReceivedKey = 'last_received_date';

  DailyLimitService(this._prefs);

  /// Vérifie si l'utilisateur peut envoyer un message aujourd'hui.
  bool canSendToday() {
    final lastSent = _prefs.getString(_lastSentKey);
    if (lastSent == null) return true;

    final lastDate = DateTime.parse(lastSent);
    final now = DateTime.now();
    return !_isSameDay(lastDate, now);
  }

  /// Vérifie si l'utilisateur peut recevoir un message aujourd'hui.
  bool canReceiveToday() {
    final lastReceived = _prefs.getString(_lastReceivedKey);
    if (lastReceived == null) return true;

    final lastDate = DateTime.parse(lastReceived);
    final now = DateTime.now();
    return !_isSameDay(lastDate, now);
  }

  /// Enregistre qu'un message a été envoyé aujourd'hui.
  Future<void> markAsSentToday() async {
    await _prefs.setString(_lastSentKey, DateTime.now().toIso8601String());
  }

  /// Enregistre qu'un message a été reçu aujourd'hui.
  Future<void> markAsReceivedToday() async {
    await _prefs.setString(_lastReceivedKey, DateTime.now().toIso8601String());
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
