import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/application/controllers/auth_controller.dart';
import 'package:kind_app/core/constants/app_constants.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_radius.dart';
import 'package:kind_app/core/theme/app_shadows.dart';
import 'package:kind_app/core/theme/app_typography.dart';
import 'package:kind_app/presentation/widgets/kind_button.dart';

/// Écran d'accueil — Daily verse + CTA Écrire.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final String _phrase;

  @override
  void initState() {
    super.initState();
    _phrase = AppConstants.contemplativePhrases[
        Random().nextInt(AppConstants.contemplativePhrases.length)];

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('One Kind Message'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
            tooltip: 'Réglages',
          ),
        ],
      ),
      body: SafeArea(
        child: authState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          ),
          error: (error, _) => _ErrorView(
            error: error.toString(),
            onRetry: () => ref.read(authControllerProvider.notifier).refresh(),
          ),
          data: (_) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Carte verset du jour — inspirée de la maquette
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: AppRadius.largeRadius,
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Citation dorée
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.gold,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _phrase,
                    style: AppTypography.bodyLarge.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Bouton principal CTA
            KindButton(
              label: 'Écrire mon message du jour',
              icon: Icons.edit_rounded,
              onPressed: () => context.go('/write'),
            ),

            const SizedBox(height: 12),

            Center(
              child: Text(
                'Reviens demain pour un nouveau message',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Erreur de connexion', style: AppTypography.headlineSmall),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            KindButton(label: 'Réessayer', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
