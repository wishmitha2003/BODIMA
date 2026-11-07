import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF123B4A);
  static const deepNavy = Color(0xFF0B2B36);
  static const teal = Color(0xFF0F766E);
  static const secondaryTeal = Color(0xFF159A8A);
  static const paleTeal = Color(0xFFDDF2ED);
  static const ivory = Color(0xFFFAF9F6);
  static const ink = Color(0xFF172B2A);
  static const muted = Color(0xFF687A76);
  static const border = Color(0xFFE5EAE7);
  static const gold = Color(0xFFD6A84B);
  static const surface = Color(0xFFF7F8F6);
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
      onPrimary: Colors.white,
      secondary: AppColors.secondaryTeal,
      surface: isDark ? const Color(0xFF142629) : Colors.white,
    );

    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0B1719) : AppColors.surface,
      useMaterial3: true,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1C3234) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isDark ? const Color(0xFF2A4140) : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF142629) : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
              color: isDark ? const Color(0xFF2A4140) : AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.border),
        selectedColor: isDark ? const Color(0xFF1C4B47) : AppColors.paleTeal,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        height: 70,
        backgroundColor: isDark ? const Color(0xFF142629) : Colors.white,
        indicatorColor: isDark ? const Color(0xFF15463F) : AppColors.paleTeal,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
