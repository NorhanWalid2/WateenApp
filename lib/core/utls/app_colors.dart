import 'package:flutter/material.dart';

abstract class AppColorsDark {
  // ── Base ─────────────────────────────────────
  static const Color primary = Color(0xFF1B2130); // main cards
  static const Color secondary = Color(0xFFE7000B); // brand red
  static const Color accent = Color(0xFFFF6B6B); // lighter red accent
  static const Color background = Color(0xFF0F172A); // scaffold background
  static const Color surface = Color(0xFF162033); // inputs / sheets / surfaces

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  // ── UI Elements ──────────────────────────────
  static const Color divider = Color(0xFF253046);
  static const Color grey = Color(0xFF64748B);
  static const Color error = Color(0xFFFF4D4F);
  static const Color star = Color(0xFFE7000B);

  // ── Containers / Special Surfaces ────────────
  static const Color offwhite = Color(0xFFE2E8F0); // for rare light chips/icons
  static const Color whiteGray = Color(0xFF20293A); // neutral container
  static const Color darkWhite = Color(0xFF334155); // disabled / alt bg
  static const Color lightDark = Color(0xFF0B1220); // darkest layer
  static const Color lightPastelPink = Color(0xFF2A1517); // soft alert bg
  static const Color softRed = Color(0xFF3A1719); // stronger alert bg
  static const Color lightGrayBlue = Color(0xFF2B3648); // cool neutral
}

abstract class AppColorsLight {
  // ── Base ─────────────────────────────────────
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFE7000B);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF1F5F9);

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);

  // ── UI Elements ──────────────────────────────
  static const Color divider = Color(0xFFE2E8F0);
  static const Color grey = Color(0xFF94A3B8);
  static const Color error = Color(0xFFE7000B);
  static const Color star = Color(0xFFE7000B);

  // ── Containers ───────────────────────────────
  static const Color offwhite = Color(0xFFF8FAFC);
  static const Color whiteGray = Color(0xFFF1F5F9);
  static const Color darkWhite = Color(0xFFE2E8F0);
  static const Color lightDark = Color(0xFF0F172A);
  static const Color lightPastelPink = Color(0xFFFEF2F2);
  static const Color softRed = Color(0xFFFFE4E6);
  static const Color lightGrayBlue = Color(0xFFCBD5E1);
}
