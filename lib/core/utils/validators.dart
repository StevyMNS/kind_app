import 'package:kind_app/core/constants/app_constants.dart';

/// Validateurs pour le contenu des messages et l'anti-spam.
class Validators {
  Validators._();

  /// Valide le contenu d'un message.
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le message ne peut pas être vide.';
    }
    if (value.trim().length < 3) {
      return 'Le message doit contenir au moins 3 caractères.';
    }
    if (value.length > AppConstants.messageMaxLength) {
      return 'Le message ne peut pas dépasser ${AppConstants.messageMaxLength} caractères.';
    }
    if (_containsSpam(value)) {
      return 'Ce message semble inapproprié.';
    }
    return null;
  }

  /// Filtrage basique anti-spam.
  static bool _containsSpam(String text) {
    final lower = text.toLowerCase();

    // Vérifie la répétition excessive de caractères
    final repeatedCharPattern = RegExp(r'(.)\1{4,}');
    if (repeatedCharPattern.hasMatch(lower)) return true;

    // Vérifie les URLs
    final urlPattern = RegExp(r'https?://|www\.');
    if (urlPattern.hasMatch(lower)) return true;

    // Vérifie le texte entièrement en majuscules (si > 10 caractères)
    if (text.length > 10 && text == text.toUpperCase()) return true;

    return false;
  }
}
