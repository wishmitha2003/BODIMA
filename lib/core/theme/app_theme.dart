import 'package:flutter/material.dart';

abstract final class AppColors {
  // Light Theme Colors
  static const navy = Color(0xFF123B4A);
  static const deepNavy = Color(0xFF0B2B36);
  static const teal = Color(0xFF0F766E);
  static const secondaryTeal = Color(0xFF159A8A);
  static const softMint = Color(0xFFDDF2ED);
  static const paleTeal = Color(0xFFDDF2ED); // Backward compatibility alias
  static const warmIvory = Color(0xFFFAF9F6);
  static const ivory = Color(0xFFFAF9F6); // Backward compatibility alias
  static const background = Color(0xFFF7F8F6);
  static const surface = Color(0xFFFFFFFF);
  static const primaryText = Color(0xFF172B2A);
  static const ink = Color(0xFF172B2A); // Backward compatibility alias
  static const secondaryText = Color(0xFF687A76);
  static const muted = Color(0xFF687A76); // Backward compatibility alias
  static const border = Color(0xFFE5EAE7);
  static const gold = Color(0xFFD6A84B);

  // Dark Theme Colors
  static const darkBackground = Color(0xFF0B1719);
  static const darkSurface = Color(0xFF142629);
  static const darkElevatedSurface = Color(0xFF1C3234);
  static const darkPrimary = Color(0xFF56C7B5);
  static const darkSecondary = Color(0xFF80D8C8);
  static const darkPrimaryText = Color(0xFFF1F7F5);
  static const darkSecondaryText = Color(0xFFA8BBB6);
  static const darkBorder = Color(0xFF2A4140);

  // Semantic Colors
  static const success = Color(0xFF15803D);
  static const warning = Color(0xFFD97706);
  static const error = Color(0xFFB42318);
  static const information = Color(0xFF2563EB);
  static const info = Color(0xFF2563EB); // Alias for information
}

abstract final class AppTheme {
  static final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final primary = isDark ? AppColors.darkPrimary : AppColors.teal;
    final secondary =
        isDark ? AppColors.darkSecondary : AppColors.secondaryTeal;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textColor =
        isDark ? AppColors.darkPrimaryText : AppColors.primaryText;
    final subtitleColor =
        isDark ? AppColors.darkSecondaryText : AppColors.secondaryText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? AppColors.deepNavy : Colors.white,
      primaryContainer: isDark ? const Color(0xFF1C4B47) : AppColors.softMint,
      onPrimaryContainer:
          isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
      secondary: secondary,
      onSecondary: isDark ? AppColors.deepNavy : Colors.white,
      secondaryContainer: isDark
          ? const Color(0xFF163C38)
          : AppColors.softMint.withValues(alpha: 0.6),
      onSecondaryContainer: isDark ? AppColors.darkSecondary : AppColors.navy,
      surface: surfaceColor,
      onSurface: textColor,
      onSurfaceVariant: subtitleColor,
      outline: borderColor,
      outlineVariant: borderColor.withValues(alpha: 0.6),
      error: AppColors.error,
      onError: Colors.white,
    );

    final textTheme = TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: textColor,
        height: 1.15,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: textColor,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: subtitleColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: subtitleColor,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: subtitleColor,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: subtitleColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: subtitleColor,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Noto Sans Sinhala', 'sans-serif'],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(color: textColor, size: 22),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
        hintStyle: TextStyle(
          color: subtitleColor.withValues(alpha: 0.8),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
        prefixIconColor: subtitleColor,
        suffixIconColor: primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: borderColor, width: 1.2),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
        selectedColor: isDark ? const Color(0xFF1B4944) : AppColors.softMint,
        disabledColor: borderColor,
        labelStyle: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: isDark ? AppColors.darkPrimary : AppColors.navy,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide(color: borderColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: surfaceColor,
        indicatorColor: isDark ? const Color(0xFF173E3B) : AppColors.softMint,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: isDark ? AppColors.darkPrimary : AppColors.navy,
              size: 24,
            );
          }
          return IconThemeData(
            color: subtitleColor,
            size: 22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkPrimary : AppColors.navy,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: subtitleColor,
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 24,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: borderColor,
        dragHandleSize: const Size(40, 4),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: borderColor,
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.15),
        valueIndicatorColor: AppColors.deepNavy,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
