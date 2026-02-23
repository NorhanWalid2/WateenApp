import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextstyle {
  static TextStyle archivo25w700(BuildContext context) => GoogleFonts.archivo(
        fontSize: 25,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      );

  static TextStyle archivo15w400(BuildContext context) => GoogleFonts.archivo(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w400,
      );

  static TextStyle archivo20(BuildContext context) => GoogleFonts.archivo(
        fontSize: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle archivo15w400Gray(BuildContext context) => GoogleFonts.archivo(
        fontSize: 15,
        color: Theme.of(context).colorScheme.outlineVariant,
        fontWeight: FontWeight.w400,
      );
}