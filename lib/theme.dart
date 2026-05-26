import 'package:flutter/material.dart';

class ClubOsTheme {
  static bool isDark = false;

  // ── Core Palette (Solar Light vs Deep Space Dark) ────────────────────────
  static Color get solarBase => isDark ? const Color(0xFF0E0E13) : const Color(0xFFF8FAFB); 
  static Color get solarSurfaceLow => isDark ? const Color(0xFF1F1F25) : const Color(0xFFF1F4F8); 
  static Color get solarSurfaceLowest => isDark ? const Color(0xFF131318) : const Color(0xFFFFFFFF); 

  // ── Brand Blues & Cyan ───────────────────────────────────────────────────
  static Color get primaryCommand => isDark ? const Color(0xFF00FBFB) : const Color(0xFF1A56DB); 
  static Color get primaryContainer => isDark ? const Color(0xFF00CCCC) : const Color(0xFF2563EB); 
  static Color get primaryLight => isDark ? const Color(0xFF0B2424) : const Color(0xFFEBF2FF); 
  static Color get primaryGlow => isDark ? const Color(0xFF00DDDD) : const Color(0xFF60A5FA); 

  // ── Accent Palette ───────────────────────────────────────────────────────
  static Color get secondaryIntelligence => isDark ? const Color(0xFFDCB8FF) : const Color(0xFF7C3AED); 
  static Color get tertiaryAnalytical => isDark ? const Color(0xFF00E6FF) : const Color(0xFF0EA5E9); 
  static const Color successGreen         = Color(0xFF10B981); 
  static const Color warningAmber         = Color(0xFFF59E0B); 
  static const Color errorRed             = Color(0xFFEF4444); 

  // ── Text & Borders ───────────────────────────────────────────────────────
  static Color get onSurfaceMain => isDark ? const Color(0xFFE4E1E9) : const Color(0xFF111827);
  static Color get onSurfaceVariant => isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
  static Color get outlineVariant => isDark ? const Color(0xFF2A292F) : const Color(0xFFE5E7EB);
  static Color get dividerColor => isDark ? const Color(0xFF1B1B20) : const Color(0xFFF3F4F6);

  // ── Spacing ──────────────────────────────────────────────────────────────
  static const double gutter      = 20.0;
  static const double gutterLarge = 28.0;
  static const double radius      = 16.0;
  static const double radiusSm    = 10.0;
  static const double radiusLg    = 24.0;

  // ── Shadows ──────────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: isDark ? const Color(0xFF00FBFB).withOpacity(0.02) : const Color(0xFF1A56DB).withOpacity(0.06), 
      offset: const Offset(0, 4), 
      blurRadius: 24, 
      spreadRadius: 0,
    ),
    BoxShadow(
      color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.04), 
      offset: const Offset(0, 1), 
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> get ambientShadow => [
    BoxShadow(
      color: isDark ? const Color(0xFF00FBFB).withOpacity(0.04) : primaryCommand.withOpacity(0.08), 
      offset: const Offset(0, 8), 
      blurRadius: 32,
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: isDark ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.04), 
      offset: const Offset(0, 2), 
      blurRadius: 8,
    ),
  ];

  // ── Status helper ─────────────────────────────────────────────────────────
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':        return successGreen;
      case 'in_progress': return tertiaryAnalytical;
      case 'pending':     return warningAmber;
      default:            return onSurfaceVariant;
    }
  }

  static Color statusBg(String status) => statusColor(status).withOpacity(0.10);

  // ── Light Theme Data ──────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: solarBase,
      primaryColor: primaryCommand,

      colorScheme: ColorScheme.light(
        primary:        primaryCommand,
        secondary:      secondaryIntelligence,
        tertiary:       tertiaryAnalytical,
        surface:        solarSurfaceLowest,
        background:     solarBase,
        onSurface:      onSurfaceMain,
        outlineVariant: outlineVariant,
        error:          errorRed,
      ),

      fontFamily: 'Inter',

      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 52,
          fontWeight: FontWeight.w800,
          letterSpacing: -2.0,
          height: 1.05,
        ),
        headlineLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          color: onSurfaceMain,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          color: onSurfaceMain,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: onSurfaceMain,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: onSurfaceVariant,
          fontSize: 13,
          height: 1.6,
        ),
        labelLarge: TextStyle(
          color: primaryCommand,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
        labelSmall: TextStyle(
          color: onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),

      cardTheme: CardThemeData(
        color: solarSurfaceLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: outlineVariant, width: 1.0),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCommand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 13),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCommand,
          side: BorderSide(color: primaryCommand, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5, fontSize: 13),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: solarSurfaceLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: primaryCommand, width: 2),
        ),
        labelStyle: TextStyle(color: onSurfaceVariant, fontSize: 13),
        hintStyle: TextStyle(color: onSurfaceVariant, fontSize: 13),
      ),

      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1, space: 1),

      appBarTheme: AppBarTheme(
        backgroundColor: solarBase,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: onSurfaceMain,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: onSurfaceMain),
      ),
    );
  }

  // ── Dark Theme Data ───────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: solarBase,
      primaryColor: primaryCommand,

      colorScheme: ColorScheme.dark(
        primary:        primaryCommand,
        secondary:      secondaryIntelligence,
        tertiary:       tertiaryAnalytical,
        surface:        solarSurfaceLowest,
        background:     solarBase,
        onSurface:      onSurfaceMain,
        outlineVariant: outlineVariant,
        error:          errorRed,
      ),

      fontFamily: 'Inter',

      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 52,
          fontWeight: FontWeight.w800,
          letterSpacing: -2.0,
          height: 1.05,
        ),
        headlineLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          color: onSurfaceMain,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          color: onSurfaceMain,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: onSurfaceMain,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: onSurfaceMain,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: onSurfaceVariant,
          fontSize: 13,
          height: 1.6,
        ),
        labelLarge: TextStyle(
          color: primaryCommand,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
        labelSmall: TextStyle(
          color: onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),

      cardTheme: CardThemeData(
        color: solarSurfaceLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: outlineVariant, width: 1.0),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCommand,
          foregroundColor: Colors.black, // Dark text on bright cyan primary button
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 13),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCommand,
          side: BorderSide(color: primaryCommand, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5, fontSize: 13),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: solarSurfaceLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: primaryCommand, width: 2),
        ),
        labelStyle: TextStyle(color: onSurfaceVariant, fontSize: 13),
        hintStyle: TextStyle(color: onSurfaceVariant, fontSize: 13),
      ),

      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1, space: 1),

      appBarTheme: AppBarTheme(
        backgroundColor: solarBase,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: onSurfaceMain,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: onSurfaceMain),
      ),
    );
  }
}