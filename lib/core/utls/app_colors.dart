import 'package:flutter/material.dart';

abstract class AppColorsDark {
  // ── Base ─────────────────────────────────────
  static const Color primary = Color(0xFF1E2235); // cards & containers
  static const Color secondary = Color(0xFFE7000B); // accent red
  static const Color accent = Color(0xFFE87D7D);
  static const Color background = Color(
    0xFF12141E,
  ); // scaffold (أغمق من primary)
  static const Color surface = Color(0xFF252840); // input fields & surfaces

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(
    0xFF9AA3B2,
  ); // أفتح من الأصلي عشان يبان

  // ── UI Elements ──────────────────────────────
  static const Color divider = Color(0xFF2E3348);
  static const Color grey = Color(0xFF6B7280);
  static const Color error = Color(0xFFE7000B);
  static const Color star = Color(0xFFE7000B);

  // ── Containers ───────────────────────────────
  static const Color offwhite = Color(0xFFEEEEEE);
  static const Color whiteGray = Color(0xFF2A2D3E);
  static const Color darkWhite = Color(0xFF2A2D3E);
  static const Color lightDark = Color(0xFF101828);
  static const Color lightPastelPink = Color(0xFF3D1A1A); // داكن مش فاتح
  static const Color softRed = Color(0xFF5C1A1A); // داكن مش فاتح
  static const Color lightGrayBlue = Color(0xFF3A3D52);
}

abstract class AppColorsLight {
  // ── Base ─────────────────────────────────────
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFE7000B);
  static const Color accent = Color(0xFFE87D7D);
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFF5F5F5);

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF4A5565);

  // ── UI Elements ──────────────────────────────
  static const Color divider = Color(0xFFE5E7EB); // أفتح من الأصلي
  static const Color grey = Color(0xFF9AA3B2);
  static const Color error = Color(0xFFE7000B);
  static const Color star = Color(0xFFE7000B);

  // ── Containers ───────────────────────────────
  static const Color offwhite = Color(0xFF757575);
  static const Color whiteGray = Color(0xFFF3F4F6);
  static const Color darkWhite = Color(0xFFEEEEEE);
  static const Color lightDark = Color(0xFF101828);
  static const Color lightPastelPink = Color(0xFFFEF2F2);
  static const Color softRed = Color(0xFFFFE4E4);
  static const Color lightGrayBlue = Color(0xFFD1D5DC);
}
