import 'package:flutter/material.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_typography.dart';

/// Écran vide contemplatif affiché quand aucun contenu n'est disponible.
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    this.message = 'Vos mots voyagent encore dans le monde...',
    this.icon = Icons.auto_awesome,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.gold.withValues(alpha: 0.5)),
            const SizedBox(height: 24),
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.grey500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
