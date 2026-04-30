import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF15171C);
  static const Color card = Color(0xFF1C1F26);
  static const Color muted = Color(0xFF252932);
  static const Color mutedLight = Color(0xFF2D323D);
  static const Color border = Color(0xFF2A2E37);
  static const Color foreground = Color(0xFFF1F2F5);
  static const Color mutedForeground = Color(0xFF9AA0AC);

  static const Color primary = Color(0xFFF97316);
  static const Color primaryDark = Color(0xFFEA580C);
  static const Color secondary = Color(0xFF2A3340);
  static const Color secondaryForeground = Color(0xFFB8D0F0);
  static const Color accent = Color(0xFF323744);
  static const Color destructive = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.secondaryForeground,
        surface: AppColors.card,
        onSurface: AppColors.foreground,
        error: AppColors.destructive,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.foreground,
        displayColor: AppColors.foreground,
      ),
      iconTheme: const IconThemeData(color: AppColors.foreground),
      dividerColor: AppColors.border,
    );
  }

  static TextStyle monoStyle({
    double size = 16,
    FontWeight weight = FontWeight.w500,
    Color? color,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color ?? AppColors.foreground,
      );
}
