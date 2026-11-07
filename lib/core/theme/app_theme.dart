import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF102A43);
  static const teal = Color(0xFF0F9D8A);
  static const paleTeal = Color(0xFFE7F7F4);
  static const ink = Color(0xFF172B4D);
  static const muted = Color(0xFF667085);
  static const surface = Color(0xFFF8FAFC);
}

abstract final class AppTheme {
  static ThemeData get light => _theme(Brightness.light);
  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: brightness,
      primary: AppColors.teal,
      surface: isDark ? const Color(0xFF101A26) : Colors.white,
    );

    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0B121B) : AppColors.surface,
      useMaterial3: true,
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF172333) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        height: 70,
        backgroundColor: isDark ? const Color(0xFF101A26) : Colors.white,
        indicatorColor:
            isDark ? const Color(0xFF15463F) : AppColors.paleTeal,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
