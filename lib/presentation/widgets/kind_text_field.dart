import 'package:flutter/material.dart';
import 'package:kind_app/core/constants/app_constants.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_typography.dart';

/// Champ de texte stylisé avec compteur de caractères.
class KindTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final int maxLength;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const KindTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.errorText,
    this.maxLength = AppConstants.messageMaxLength,
    this.maxLines = 5,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText ?? 'Écrivez votre message bienveillant...',
            errorText: errorText,
            counterText: '',
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            final length = value.text.length;
            final isNearLimit = length > maxLength * 0.8;
            return Text(
              '$length / $maxLength',
              style: AppTypography.bodySmall.copyWith(
                color: isNearLimit ? AppColors.gold : AppColors.grey500,
                fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          },
        ),
      ],
    );
  }
}
