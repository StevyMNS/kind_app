import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/application/controllers/auth_controller.dart';
import 'package:kind_app/core/constants/app_constants.dart';
import 'package:kind_app/core/services/stats_service.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_radius.dart';
import 'package:kind_app/core/theme/app_shadows.dart';
import 'package:kind_app/core/theme/app_typography.dart';
import 'package:kind_app/core/theme/theme_provider.dart';

/// Écran Profil & Réglages.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _remindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    // Récupérer le streak depuis le service (synchrone car basé sur SharedPreferences injecté)
    final statsService = ref.watch(statsServiceProvider);
    final streak = statsService.getActiveDaysStreak();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'settings.title'.tr(),
          style: const TextStyle(fontSize: 14, letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            // Section Jours Actifs (Streak)
            _buildStreakSection(streak),

            const SizedBox(height: 48),

            // Section Préférences Minimales
            _buildPreferencesSection(isDark),

            const SizedBox(height: 32),

            // Section À propos (conservée comme demandé)
            Text(
              'settings.about'.tr(),
              style: const TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.favorite_rounded,
              title: 'settings.concept_title'.tr(),
              subtitle: 'settings.concept_subtitle'.tr(),
            ),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: AppConstants.appName,
              subtitle: 'settings.version'.tr(args: [AppConstants.appVersion]),
            ),

            const SizedBox(height: 48),

            // Liens footer
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'settings.privacy_policy'.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ),
            ),

            Center(
              child: TextButton(
                onPressed: () => _showDeleteDialog(context, ref),
                child: Text(
                  'settings.delete_account'.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                '${'settings.version'.tr(args: [AppConstants.appVersion])} • ${'settings.anonymous_badge'.tr()}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.grey300,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(int streak) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Text(
              streak.toString(),
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.gold,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          'settings.streak_title'.tr(),
          style: AppTypography.headlineSmall.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'settings.streak_subtitle'.tr(),
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(bool isDark) {
    final languageCode = context.locale.languageCode;
    final Map<String, String> langNames = {
      'en': 'English',
      'fr': 'Français',
      'es': 'Español',
      'pt': 'Português',
      'ja': '日本語',
      'zh': '中文',
    };
    final currentLangName = langNames[languageCode] ?? 'English';

    return Column(
      children: [
        _SettingsTile(
          icon: Icons.translate_rounded,
          title: 'settings.lang_title'.tr(),
          trailing: Text(
            currentLangName,
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
          onTap: _showLanguageModal,
        ),
        _SettingsTile(
          icon: Icons.schedule_rounded,
          title: 'settings.timezone_title'.tr(),
          trailing: Text(
            'Auto', // Simplifié en Auto (au lieu de Paris statique)
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ),
        _SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'settings.reminders_title'.tr(),
          trailing: Switch.adaptive(
            value: _remindersEnabled,
            onChanged: (val) => setState(() => _remindersEnabled = val),
            activeTrackColor: AppColors.gold,
          ),
        ),
        _SettingsTile(
          icon: Icons.dark_mode_outlined,
          title: 'settings.dark_mode_title'.tr(),
          trailing: Switch.adaptive(
            value: isDark,
            onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
            activeTrackColor: AppColors.gold,
          ),
        ),
      ],
    );
  }

  void _showLanguageModal() {
    final Map<String, String> languages = {
      'en': 'English',
      'fr': 'Français',
      'es': 'Español',
      'pt': 'Português',
      'ja': '日本語',
      'zh': '中文',
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('settings.lang_title'.tr(), style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              ...languages.entries.map((entry) {
                final isSelected = context.locale.languageCode == entry.key;
                return ListTile(
                  title: Text(entry.value, style: AppTypography.bodyMedium),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.gold,
                        )
                      : null,
                  onTap: () {
                    context.setLocale(Locale(entry.key));
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        title: Text(
          'settings.dialog_delete_title'.tr(),
          style: AppTypography.headlineSmall,
        ),
        content: Text(
          'settings.dialog_delete_content'.tr(),
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'settings.btn_cancel'.tr(),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Réinitialiser les stats et se déconnecter
              ref.read(statsServiceProvider).clearStats();
              ref.read(authControllerProvider.notifier).signOut();
              context.go('/');
            },
            child: Text(
              'settings.btn_delete'.tr(),
              style: AppTypography.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppRadius.largeRadius,
        boxShadow: AppShadows.soft,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        leading: Icon(icon, color: AppColors.grey500, size: 22),
        title: Text(title, style: AppTypography.titleMedium),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              )
            : null,
        trailing:
            trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.grey300,
            ),
        onTap: onTap,
      ),
    );
  }
}
