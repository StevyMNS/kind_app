library;

/// Utilitaires pour la gestion des pays et émojis.
class CountryUtils {
  CountryUtils._();

  /// Convertit un code pays (ISO 3166-1 alpha-2) en émoji drapeau.
  /// Exemple: "FR" -> "🇫🇷"
  static String? countryCodeToEmoji(String? countryCode) {
    if (countryCode == null || countryCode.length != 2) return null;
    
    final int firstChar = countryCode.toUpperCase().codeUnitAt(0) + 127397;
    final int secondChar = countryCode.toUpperCase().codeUnitAt(1) + 127397;
    
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}
