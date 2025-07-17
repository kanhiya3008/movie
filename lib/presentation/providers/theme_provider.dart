import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData get theme => AppTheme.darkTheme;

  // Always return dark mode since we only have one theme
  bool get isDarkMode => true;
  bool get isLightMode => false;
  bool get isSystemMode => false;

  // Single theme data
  ThemeData get lightTheme => AppTheme.darkTheme;
  ThemeData get darkTheme => AppTheme.darkTheme;

  // No theme switching needed
  String getThemeModeString() => 'Dark';
  IconData getThemeIcon() => Icons.dark_mode;
  Color getThemeColor() => const Color(0xFF1c2838);
}
