import 'package:flutter/material.dart';

abstract final class AppColors {
  // --- Primary ---
  static const Color accent = Color(0xFF5856D6);
  static const Color accentDim = Color(0xFF3F3BBD);
  static const Color accentSurface = Color(0xFF1E1C4A);

  // --- Backgrounds ---
  static const Color backgroundDark = Color(0xFF0D0D14);
  static const Color backgroundLight = Color(0xFFF9F9FC);

  // --- Surfaces ---
  static const Color surfaceDark = Color(0xFF14141F);
  static const Color surfaceDark2 = Color(0xFF1E1E2E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLight2 = Color(0xFFF3F3F6);

  // --- Text ---
  static const Color primaryText = Color(0xFFE8E8F0);
  static const Color primaryTextLight = Color(0xFF1A1C1E);
  static const Color secondaryText = Color(0xFF9090A8);
  static const Color secondaryTextLight = Color(0xFF464554);

  // --- States ---
  static const Color successColor = Color(0xFF34C759);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color warningColor = Color(0xFFFF9F0A);

  // --- Dividers / Borders ---
  static const Color outline = Color(0xFF2C2C40);
  static const Color outlineLight = Color(0xFFC7C4D6);

  // --- Overlays ---
  static const Color overlay = Color(0x66000000);
  static const Color cardOverlay = Color(0xFF1A1A2A);
}
