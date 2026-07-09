import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // Headline Large — 32px, SemiBold
  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.64,
    color: AppColors.primaryText,
    height: 1.25,
  );

  // Headline Medium — 28px, Medium
  static TextStyle get headingMedium => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.28,
    color: AppColors.primaryText,
    height: 1.29,
  );

  // Title Large — 22px, Medium
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
    height: 1.27,
  );

  // Title Medium — 18px, SemiBold
  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.33,
  );

  // Body Large — 18px, Regular
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.56,
  );

  // Body Medium — 16px, Regular
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.5,
  );

  // Label Large — 14px, Medium
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.primaryText,
    height: 1.43,
  );

  // Label Small — 12px, Medium
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.secondaryText,
    height: 1.33,
  );

  // Caption — 12px, Regular
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.33,
  );

  // Button — 16px, SemiBold
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.1,
  );

  // Overline — 11px, SemiBold, all-caps feel
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.secondaryText,
    height: 1.45,
  );

  // Mono / code display (room code numbers)
  static TextStyle get roomCode => GoogleFonts.inter(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: 8,
    color: AppColors.primary,
  );
}
