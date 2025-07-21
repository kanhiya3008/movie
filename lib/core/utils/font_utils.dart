import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/font_constants.dart';

class FontUtils {
  // Primary Font (Inter) - Clean and modern
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Secondary Font (Poppins) - For accents and special text
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Roboto Font - Alternative option
  static TextStyle roboto({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Open Sans Font - Clean and readable
  static TextStyle openSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.openSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Lato Font - Modern and friendly
  static TextStyle lato({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Montserrat Font - Elegant and modern
  static TextStyle montserrat({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Quick access methods for common text styles
  static TextStyle get heading1 => inter(
    fontSize: FontConstants.headlineLarge,
    fontWeight: FontConstants.bold,
  );

  static TextStyle get heading2 => inter(
    fontSize: FontConstants.headlineMedium,
    fontWeight: FontConstants.semiBold,
  );

  static TextStyle get heading3 => inter(
    fontSize: FontConstants.headlineSmall,
    fontWeight: FontConstants.semiBold,
  );

  // Name-Desktop/Body/MediumRegular
  static TextStyle get bodyText => inter(
    fontSize: FontConstants.bodyMedium,
    fontWeight: FontConstants.medium, // Medium weight for MediumRegular
  );

  static TextStyle get buttonText => inter(
    fontSize: FontConstants.buttonMedium,
    fontWeight: FontConstants.semiBold,
  );

  static TextStyle get caption =>
      inter(fontSize: FontConstants.caption, fontWeight: FontConstants.regular);

  // Specific style for Name-Desktop/Body/MediumRegular
  static TextStyle get nameDesktopBodyMediumRegular => inter(
    fontSize: FontConstants.bodyMedium,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWider,
  );
}
