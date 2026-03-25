import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kind_app/core/constants/env_config.dart';
import 'package:kind_app/core/router/app_router.dart';
import 'package:kind_app/core/services/daily_limit_service.dart';
import 'package:kind_app/core/services/stats_service.dart';
import 'package:kind_app/core/theme/app_theme.dart';
import 'package:kind_app/core/theme/theme_provider.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser la localisation de l'UI
  await EasyLocalization.ensureInitialized();

  // Initialiser les locales pour le formatage des dates
  await initializeDateFormatting('fr_FR', null);

  // Charger les variables d'environnement
  await dotenv.load(fileName: '.env');

  // Initialiser Supabase
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  AppLogger.info('Supabase initialisé', 'INIT');
  AppLogger.info('Environnement configuré: ${EnvConfig.isConfigured}', 'INIT');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('es'),
        Locale('pt'),
        Locale('ja'),
        Locale('zh'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: ProviderScope(
        overrides: [
          dailyLimitServiceProvider.overrideWithValue(DailyLimitService(prefs)),
          statsServiceProvider.overrideWithValue(StatsService(prefs)),
        ],
        child: const KindApp(),
      ),
    ),
  );
}

/// Application principale One Kind Message.
class KindApp extends ConsumerWidget {
  const KindApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'app_name'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
