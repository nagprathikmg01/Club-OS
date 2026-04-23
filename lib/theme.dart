import 'package:flutter/material.dart';

class ClubOsTheme {
  // --- Solar Technical Palette (The Digital Observatory) ---
  static const Color solarBase = Color(0xFFF7F9FB); // Level 0 Foundation
  static const Color solarSurfaceLow = Color(0xFFF2F4F6); // Level 1 Tonal Layer
  static const Color solarSurfaceLowest = Color(0xFFFFFFFF); // Level 2 Active Layer
  
  static const Color primaryCommand = Color(0xFF004AC6); // Precision Blue
  static const Color primaryContainer = Color(0xFF2563EB); // Solar Flare Blue
  
  static const Color secondaryIntelligence = Color(0xFF4B41E1); // Neural Purple
  static const Color tertiaryAnalytical = Color(0xFF824500); // Warning Amber
  
  static const Color onSurfaceMain = Color(0xFF191C1E); // Text optimized for contrast
  static const Color onSurfaceVariant = Color(0xFF434655); // Muted metadata
  static const Color outlineVariant = Color(0xFFC3C6D7); // Tonal boundaries (20% opacity)

  static const double gutter = 24.0;
  static const double gutterLarge = 32.0;

  // --- Theme Data ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: solarBase,
      primaryColor: primaryCommand,
      
      colorScheme: const ColorScheme.light(
        primary: primaryCommand,
        secondary: secondaryIntelligence,
        tertiary: tertiaryAnalytical,
        surface: solarSurfaceLowest,
        background: solarBase,
        onSurface: onSurfaceMain,
        outlineVariant: outlineVariant,
      ),

      // Typography: High-End Editorial (Inter)
      fontFamily: 'Inter', 
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: onSurfaceMain, 
          fontSize: 48, 
          fontWeight: FontWeight.w600,
          letterSpacing: -1.2,
        ),
        headlineSmall: TextStyle(
          color: onSurfaceMain, 
          fontSize: 24, 
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2, // Wide-tracked
        ),
        titleMedium: TextStyle(
          color: onSurfaceMain, 
          fontSize: 18, 
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: onSurfaceVariant, 
          fontSize: 14, 
          height: 1.6,
        ),
        labelSmall: TextStyle(
          color: primaryCommand, 
          fontSize: 11, 
          fontWeight: FontWeight.bold, 
          letterSpacing: 1.0,
        ),
      ),

      // Premium Technical Cards
      cardTheme: CardThemeData(
        color: solarSurfaceLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: outlineVariant.withOpacity(0.2), width: 1.0),
        ),
      ),

      // Solar Flare Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCommand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // md radius
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 13),
          elevation: 0,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(borderSide: BorderSide(color: outlineVariant.withOpacity(0.2))),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: outlineVariant.withOpacity(0.2))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: primaryCommand, width: 2)),
        labelStyle: const TextStyle(color: onSurfaceVariant, fontSize: 12),
      ),
    );
  }

  // Shadow reserved for Modals
  static List<BoxShadow> get ambientShadow => [
    BoxShadow(
      color: primaryCommand.withOpacity(0.05),
      offset: const Offset(0, 20),
      blurRadius: 40,
    ),
  ];
}