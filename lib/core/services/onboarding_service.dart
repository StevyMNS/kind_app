import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer l'état de l'onboarding.
class OnboardingService {
  static const String _key = 'onboarding_completed';

  /// Vérifie si l'onboarding a déjà été complété.
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Marque l'onboarding comme complété.
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  /// Reset pour les tests.
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
