import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// Thème global de l'application (Light & Dark).
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: const ColorScheme.light(
      primary: AppColors.midnightBlue,
      secondary: AppColors.gold,
      surface: AppColors.white,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.grey900,
      onError: AppColors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.midnightBlue,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.midnightBlue,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.midnightBlue,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.grey900),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.grey900),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.grey700),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.grey900),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.grey500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        textStyle: AppTypography.labelLarge,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.midnightBlue,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        side: const BorderSide(color: AppColors.midnightBlue),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.mist,
      border: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: const BorderSide(color: AppColors.gold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: AppColors.midnightBlue,
      ),
      iconTheme: const IconThemeData(color: AppColors.midnightBlue),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey300,
      thickness: 0.5,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkSurface,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.mist,
      surface: AppColors.darkCard,
      error: AppColors.error,
      onPrimary: AppColors.darkSurface,
      onSecondary: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      onError: AppColors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.darkText,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.darkText,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.darkText,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.darkText),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.darkText,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.grey300),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.grey300),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.darkText),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.grey500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkSurface,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        textStyle: AppTypography.labelLarge,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gold,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        side: const BorderSide(color: AppColors.gold),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: const BorderSide(color: AppColors.gold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: AppColors.darkText,
      ),
      iconTheme: const IconThemeData(color: AppColors.gold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.grey700.withValues(alpha: 0.3),
      thickness: 0.5,
    ),
  );
}
