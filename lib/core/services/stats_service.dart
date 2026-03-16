import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final statsServiceProvider = Provider<StatsService>((ref) {
  throw UnimplementedError('Initialisé dans le main');
});

/// Service gérant les statistiques de l'utilisateur (série de jours actifs).
class StatsService {
  final SharedPreferences _prefs;

  static const String _activeDaysStreakKey = 'active_days_streak';
  static const String _lastActiveDateKey = 'last_active_date';

  StatsService(this._prefs);

  /// Récupère la série de jours actifs consécutifs.
  int getActiveDaysStreak() {
    return _prefs.getInt(_activeDaysStreakKey) ?? 0;
  }

  /// Met à jour la série (à appeler lors d'une action comme envoyer ou recevoir).
  Future<void> recordActivity() async {
    final lastActiveString = _prefs.getString(_lastActiveDateKey);
    final now = DateTime.now();

    if (lastActiveString == null) {
      // Première activité
      await _prefs.setInt(_activeDaysStreakKey, 1);
      await _prefs.setString(_lastActiveDateKey, now.toIso8601String());
      return;
    }

    final lastActive = DateTime.parse(lastActiveString);
    final difference = _getMidnightDifference(lastActive, now);

    if (difference == 1) {
      // Activité le jour suivant : on incrémente la série
      final currentStreak = getActiveDaysStreak();
      await _prefs.setInt(_activeDaysStreakKey, currentStreak + 1);
      await _prefs.setString(_lastActiveDateKey, now.toIso8601String());
    } else if (difference > 1) {
      // Plus d'un jour passé : on reset la série
      await _prefs.setInt(_activeDaysStreakKey, 1);
      await _prefs.setString(_lastActiveDateKey, now.toIso8601String());
    }
    // Si difference == 0 (même jour), on ne fait rien
  }

  /// Efface les statistiques (lors de la déconnexion par ex).
  Future<void> clearStats() async {
    await _prefs.remove(_activeDaysStreakKey);
    await _prefs.remove(_lastActiveDateKey);
  }

  int _getMidnightDifference(DateTime date1, DateTime date2) {
    final d1 = DateTime(date1.year, date1.month, date1.day);
    final d2 = DateTime(date2.year, date2.month, date2.day);
    return d2.difference(d1).inDays;
  }
}
