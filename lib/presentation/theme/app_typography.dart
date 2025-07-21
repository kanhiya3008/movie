import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import '../../core/constants/font_constants.dart';

class AppTypography {
  // Display Styles
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: FontConstants.displayLarge,
    fontWeight: FontConstants.bold,
    letterSpacing: FontConstants.letterSpacingTight,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: FontConstants.displayMedium,
    fontWeight: FontConstants.bold,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => GoogleFonts.inter(
    fontSize: FontConstants.displaySmall,
    fontWeight: FontConstants.bold,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  // Headline Styles
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: FontConstants.headlineLarge,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: FontConstants.headlineMedium,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: FontConstants.headlineSmall,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  // Title Styles
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: FontConstants.titleLarge,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: FontConstants.titleMedium,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWide,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: FontConstants.titleSmall,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWide,
    color: AppColors.textPrimary,
  );

  // Body Styles
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: FontConstants.bodyLarge,
    fontWeight: FontConstants.regular,
    letterSpacing: FontConstants.letterSpacingWidest,
    color: AppColors.textPrimary,
  );

  // Name-Desktop/Body/MediumRegular
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: FontConstants.bodyLarge,
    fontWeight: FontConstants.semiBold, // Medium weight for MediumRegular
    letterSpacing: FontConstants.letterSpacingWider,
    color: AppColors.textPrimary,
  );

  // Name-Desktop/Body/MediumRegular
  static TextStyle get bodyMedium1 => GoogleFonts.inter(
    fontSize: FontConstants.bodyMedium,
    fontWeight: FontConstants.semiBold, // Medium weight for MediumRegular
    letterSpacing: FontConstants.letterSpacingWider,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: FontConstants.bodySmall,
    fontWeight: FontConstants.regular,
    letterSpacing: FontConstants.letterSpacingWidest,
    color: AppColors.textSecondary,
  );

  // Label Styles
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: FontConstants.labelLarge,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWide,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: FontConstants.labelMedium,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWidest,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: FontConstants.labelSmall,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWidest,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelSmallLogin => GoogleFonts.inter(
    fontSize: FontConstants.labelSmall,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWidest,
    color: AppColors.textPrimary,
  );

  // Button Styles
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: FontConstants.buttonLarge,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingWide,
    color: AppColors.textInverse,
  );

  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: FontConstants.buttonMedium,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingWide,
    color: AppColors.textInverse,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: FontConstants.buttonSmall,
    fontWeight: FontConstants.semiBold,
    letterSpacing: FontConstants.letterSpacingWide,
    color: AppColors.textInverse,
  );

  // Caption Styles
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: FontConstants.caption,
    fontWeight: FontConstants.regular,
    letterSpacing: FontConstants.letterSpacingWidest,
    color: AppColors.textTertiary,
  );

  static TextStyle get overline => GoogleFonts.inter(
    fontSize: FontConstants.overline,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingExtraWide,
    color: AppColors.textTertiary,
  );

  // Filter Text Style - Color: #3E4B5A, Size: 14, Weight: 400, Font: Inter
  static TextStyle get filterText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: FontConstants.letterSpacingNormal,
    color: const Color(0xFFCBD5E2),
  );
}
