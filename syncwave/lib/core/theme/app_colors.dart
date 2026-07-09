import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary — Periwinkle
  static const Color primary = Color(0xFF5856D6);
  static const Color primaryDark = Color(0xFF3F3BBD);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE2DFFF);
  static const Color onPrimaryContainer = Color(0xFF0C006A);

  // Background & Surfaces
  static const Color background = Color(0xFFF9F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F6);
  static const Color surfaceContainer = Color(0xFFEDEEF1);
  static const Color surfaceContainerHigh = Color(0xFFE8E8EB);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E5);
  static const Color surfaceDim = Color(0xFFD9DADD);

  // Text
  static const Color onSurface = Color(0xFF1A1C1E);
  static const Color onSurfaceVariant = Color(0xFF464554);
  static const Color primaryText = Color(0xFF1A1C1E);
  static const Color secondaryText = Color(0xFF464554);

  // Borders
  static const Color outline = Color(0xFF777585);
  static const Color outlineVariant = Color(0xFFC7C4D6);

  // States
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF1B6B3A);
  static const Color successContainer = Color(0xFFB7F0CB);

  // Secondary
  static const Color secondary = Color(0xFF5C5E66);
  static const Color secondaryContainer = Color(0xFFE2E2EC);
  static const Color onSecondaryContainer = Color(0xFF62646C);

  // Accents
  static const Color accentColor = Color(0xFF5856D6);

  // Shadows (periwinkle-tinted, very low opacity)
  static const Color shadow = Color(0x145856D6);

  // Inverse
  static const Color inverseSurface = Color(0xFF2F3133);
  static const Color inverseOnSurface = Color(0xFFF0F0F3);
  static const Color inversePrimary = Color(0xFFC2C1FF);

  // Misc
  static const Color scrim = Color(0x80000000);
}
