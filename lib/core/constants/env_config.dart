import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration d'environnement (dev/prod).
class EnvConfig {
  EnvConfig._();

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
