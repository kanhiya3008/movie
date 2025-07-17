import 'package:flutter/material.dart';

class AppColors {
  // Single Color Theme - Using only 0xFF1c2838
  static const Color primary = Color(0xFF1c2838);
  static const Color primaryLight = Color(0xFF2a3a4a);
  static const Color primaryDark = Color(0xFF0f1a28);

  // Secondary and Accent Colors (using variations of the main color)
  static const Color secondary = Color(0xFF1c2838);
  static const Color accent = Color(0xFF1c2838);

  // Background Colors
  static const Color background = Color(0xFF1c2838);
  static const Color surface = Color(0xFF1c2838);
  static const Color card = Color(0xFF1c2838);
  static const Color cardLight = Color(0xFF2a3a4a);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8B8);
  static const Color textTertiary = Color(0xFF8B8B8B);
  static const Color textInverse = Color(0xFF1c2838);

  // Status Colors (using variations of the main color)
  static const Color success = Color(0xFF1c2838);
  static const Color warning = Color(0xFF1c2838);
  static const Color error = Color(0xFF1c2838);
  static const Color info = Color(0xFF1c2838);

  // Gradient using only the main color
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppColorScheme {
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.textInverse,
    secondary: AppColors.primary,
    onSecondary: AppColors.textInverse,
    tertiary: AppColors.primary,
    onTertiary: AppColors.textInverse,
    error: AppColors.error,
    onError: AppColors.textInverse,
    background: AppColors.background,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceVariant: AppColors.card,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.textTertiary,
    outlineVariant: AppColors.cardLight,
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: AppColors.surface,
    onInverseSurface: AppColors.textPrimary,
    inversePrimary: AppColors.primaryLight,
  );
}
