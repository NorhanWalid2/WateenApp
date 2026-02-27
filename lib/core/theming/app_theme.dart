import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_colors.dart';

abstract class AppTheme {
  // ─────────────────────────────────────────────
  //  Dark Theme
  // ─────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColorsDark.primary,
      secondary: AppColorsDark.secondary,
      surface: AppColorsDark.surface,
      error: AppColorsDark.error,
      tertiary: AppColorsDark.accent,
      onPrimary: AppColorsDark.textPrimary,
      onSecondary: AppColorsDark.textPrimary,
      onSurface: AppColorsDark.textPrimary,
      onSurfaceVariant: AppColorsDark.textSecondary,
      primaryContainer: AppColorsDark.lightPastelPink,
      onPrimaryContainer: AppColorsDark.lightDark,
      secondaryContainer: AppColorsDark.softRed,
      onSecondaryContainer: AppColorsDark.textPrimary,
      onInverseSurface: AppColorsDark.offwhite,
      outline: AppColorsDark.divider,
      outlineVariant: AppColorsDark.grey,
      surfaceContainerHighest: AppColorsDark.whiteGray,
      surfaceContainerHigh: AppColorsDark.darkWhite,
      inverseSurface: AppColorsDark.lightDark,
      onError: AppColorsDark.textPrimary,
      onTertiary: AppColorsLight.lightGrayBlue,
    ),
    scaffoldBackgroundColor: AppColorsDark.background,

    // ── AppBar ──────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.primary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColorsDark.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColorsDark.textPrimary,
      ),
    ),

    // ── Bottom Navigation Bar ───────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColorsDark.primary,
      selectedItemColor: AppColorsDark.secondary,
      unselectedItemColor: AppColorsDark.textSecondary,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),

    // ── Input Decoration ────────────────────
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColorsDark.surface,
      filled: true,
      hintStyle: const TextStyle(color: AppColorsDark.textSecondary),
      labelStyle: const TextStyle(color: AppColorsDark.textSecondary),
      floatingLabelStyle: const TextStyle(color: AppColorsDark.secondary),
      prefixIconColor: AppColorsDark.grey,
      suffixIconColor: AppColorsDark.grey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: AppColorsDark.secondary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColorsDark.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColorsDark.error, width: 2),
      ),
      errorStyle: const TextStyle(color: AppColorsDark.error, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    // ── Elevated Button ─────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.secondary,
        foregroundColor: AppColorsDark.textPrimary,
        disabledBackgroundColor: AppColorsDark.grey,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── Outlined Button ─────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsDark.secondary,
        side: const BorderSide(color: AppColorsDark.secondary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── Text Button ─────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsDark.secondary,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── FloatingActionButton ────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColorsDark.secondary,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 4,
    ),

    // ── Card ────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColorsDark.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),

    // ── Divider ─────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColorsDark.divider,
      thickness: 1,
      space: 1,
    ),

    // ── Icon ────────────────────────────────
    iconTheme: const IconThemeData(color: AppColorsDark.textPrimary, size: 24),

    // ── Switch ──────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.secondary;
        }
        return AppColorsDark.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.softRed;
        }
        return AppColorsDark.surface;
      }),
    ),

    // ── Checkbox ────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.secondary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColorsDark.textPrimary),
      side: const BorderSide(color: AppColorsDark.divider, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // ── Dialog ──────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsDark.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColorsDark.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColorsDark.textSecondary,
        fontSize: 14,
      ),
    ),

    // ── BottomSheet ─────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsDark.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      dragHandleColor: AppColorsDark.grey,
      showDragHandle: true,
    ),

    // ── SnackBar ────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColorsDark.offwhite,
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColorsDark.lightDark,
        fontSize: 14,
      ),
      actionTextColor: AppColorsDark.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Tab Bar ─────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColorsDark.secondary,
      unselectedLabelColor: AppColorsDark.grey,
      indicatorColor: AppColorsDark.secondary,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 14),
    ),

    // ── Progress Indicator ──────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColorsDark.secondary,
      linearTrackColor: AppColorsDark.surface,
    ),

    // ── Text Theme ──────────────────────────
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColorsDark.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColorsDark.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColorsDark.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColorsDark.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColorsDark.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColorsDark.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColorsDark.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColorsDark.divider,
      ),
    ),
  );

  // ─────────────────────────────────────────────
  //  Light Theme
  // ─────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.primary,
      secondary: AppColorsLight.secondary,
      surface: AppColorsLight.surface,
      error: AppColorsLight.error,
      onPrimary: AppColorsLight.textPrimary,
      onSecondary: Colors.white,
      onSurface: AppColorsLight.textPrimary,
      onSurfaceVariant: AppColorsLight.textSecondary,
      primaryContainer: AppColorsLight.lightPastelPink,
      onPrimaryContainer: AppColorsLight.lightDark,
      secondaryContainer: AppColorsLight.softRed,
      onSecondaryContainer: Colors.white,
      onInverseSurface: AppColorsLight.offwhite,
      outline: AppColorsLight.divider,
      outlineVariant: AppColorsLight.grey,
      surfaceContainerHighest: AppColorsLight.whiteGray,
      surfaceContainerHigh: AppColorsLight.darkWhite,
      inverseSurface: AppColorsLight.lightDark,
      onError: Colors.white,
      onTertiary: AppColorsLight.lightGrayBlue,
      background: AppColorsLight.background,
    ),
    scaffoldBackgroundColor: AppColorsLight.background,

    // ── AppBar ──────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.primary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColorsLight.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColorsLight.textPrimary,
      ),
    ),

    // ── Bottom Navigation Bar ───────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColorsLight.primary,
      selectedItemColor: AppColorsLight.secondary,
      unselectedItemColor: AppColorsLight.textSecondary,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),

    // ── Input Decoration ────────────────────
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColorsLight.surface,
      filled: true,
      hintStyle: const TextStyle(color: AppColorsLight.textSecondary),
      labelStyle: const TextStyle(color: AppColorsLight.textSecondary),
      floatingLabelStyle: const TextStyle(color: AppColorsLight.secondary),
      prefixIconColor: AppColorsLight.grey,
      suffixIconColor: AppColorsLight.grey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: AppColorsLight.secondary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColorsLight.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColorsLight.error, width: 2),
      ),
      errorStyle: const TextStyle(color: AppColorsLight.error, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    // ── Elevated Button ─────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsLight.secondary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColorsLight.grey,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── Outlined Button ─────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsLight.secondary,
        side: const BorderSide(color: AppColorsLight.secondary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── Text Button ─────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsLight.secondary,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── FloatingActionButton ────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColorsLight.secondary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // ── Card ────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColorsLight.primary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),

    // ── Divider ─────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColorsLight.divider,
      thickness: 1,
      space: 1,
    ),

    // ── Icon ────────────────────────────────
    iconTheme: const IconThemeData(color: AppColorsLight.textPrimary, size: 24),

    // ── Switch ──────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsLight.secondary;
        }
        return AppColorsLight.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsLight.lightPastelPink;
        }
        return AppColorsLight.surface;
      }),
    ),

    // ── Checkbox ────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsLight.secondary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: AppColorsLight.divider, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // ── Dialog ──────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsLight.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColorsLight.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColorsLight.textSecondary,
        fontSize: 14,
      ),
    ),

    // ── BottomSheet ─────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsLight.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      dragHandleColor: AppColorsLight.grey,
      showDragHandle: true,
    ),

    // ── SnackBar ────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColorsLight.lightDark,
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white,
        fontSize: 14,
      ),
      actionTextColor: AppColorsLight.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Tab Bar ─────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColorsLight.secondary,
      unselectedLabelColor: AppColorsLight.grey,
      indicatorColor: AppColorsLight.secondary,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 14),
    ),

    // ── Progress Indicator ──────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColorsLight.secondary,
      linearTrackColor: AppColorsLight.surface,
    ),

    // ── Text Theme ──────────────────────────
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColorsLight.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColorsLight.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColorsLight.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColorsLight.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColorsLight.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColorsLight.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColorsLight.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColorsLight.divider,
      ),
    ),
  );
}
