import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography constants for Mi Yantzaza.
/// Manrope for editorial headlines, Public Sans for body/UI text.
class AppTypography {
  AppTypography._();

  // ─── Display (Manrope) ─────────────────────────────────────
  static final TextStyle displayLg = GoogleFonts.manrope(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1.1,
  );

  static final TextStyle displayMd = GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.7,
  );

  static final TextStyle displaySm = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // ─── Headlines (Manrope) ──────────────────────────────────
  static final TextStyle headlineLg = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.4,
  );

  static final TextStyle headlineMd = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static final TextStyle headlineSm = GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.35,
    letterSpacing: 0,
  );

  // ─── Title (Manrope) ──────────────────────────────────────
  static final TextStyle titleLg = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  static final TextStyle titleMd = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.01,
  );

  static final TextStyle titleSm = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.01,
  );

  // ─── Body (Public Sans) ──────────────────────────────────
  static final TextStyle bodyLg = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.01,
  );

  static final TextStyle bodyMd = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
    letterSpacing: 0.01,
  );

  static final TextStyle bodySm = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.02,
  );

  // ─── Label (Public Sans) ──────────────────────────────────
  static final TextStyle labelLg = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.05,
  );

  static final TextStyle labelMd = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.08,
  );

  static final TextStyle labelSm = GoogleFonts.publicSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0.1,
  );

  // ─── Utility ──────────────────────────────────────────────
  static final TextStyle buttonText = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.02,
  );

  static final TextStyle overline = GoogleFonts.publicSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.12,
    height: 1.2,
  );
}
