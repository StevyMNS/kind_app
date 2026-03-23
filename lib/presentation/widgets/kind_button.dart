import 'package:flutter/material.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_radius.dart';
import 'package:kind_app/core/theme/app_shadows.dart';
import 'package:kind_app/core/theme/app_typography.dart';

/// Bouton principal du design system.
class KindButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const KindButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return _buildOutlined(context);
    }
    return _buildElevated(context);
  }

  Widget _buildElevated(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.largeRadius,
        boxShadow: onPressed != null ? AppShadows.goldGlow : null,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget _buildOutlined(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Flexible(child: Text(label, style: AppTypography.labelLarge)),
        ],
      );
    }

    return Text(label, style: AppTypography.labelLarge);
  }
}
