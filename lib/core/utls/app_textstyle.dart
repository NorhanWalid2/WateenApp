import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextstyle {
  static TextStyle arimo30(BuildContext context) => GoogleFonts.archivo(
    fontSize: 30,
    color: Theme.of(context).colorScheme.inverseSurface,
    fontWeight: FontWeight.bold,
  );

  static TextStyle arimo16(BuildContext context) => GoogleFonts.archivo(
    fontSize: 16,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    fontWeight: FontWeight.w400,
  );

  static TextStyle arimo24(BuildContext context) => GoogleFonts.arimo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.inverseSurface,
  );

  static TextStyle archivo15w400Gray(BuildContext context) =>
      GoogleFonts.archivo(
        fontSize: 15,
        color: Theme.of(context).colorScheme.outlineVariant,
        fontWeight: FontWeight.w400,
      );
  static TextStyle arimo24w700(BuildContext context) {
    return GoogleFonts.arimo(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
