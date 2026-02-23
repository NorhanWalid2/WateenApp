import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/utls/app_colors.dart';

abstract class AppTextstyle {
  static TextStyle archivo25w700 = GoogleFonts.archivo(
        fontSize: 25,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
      ),
      archivo15w400 = GoogleFonts.archivo(
        fontSize: 15,
        color: AppColors.white,
        fontWeight: FontWeight.w400,
      ),
      archivo20 = GoogleFonts.archivo(
        fontSize: 20,
        color: Colors.black,
        // fontWeight: FontWeight.w200,
      );
}
