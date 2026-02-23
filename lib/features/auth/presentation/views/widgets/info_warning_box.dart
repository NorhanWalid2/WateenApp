import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/utls/app_assets.dart';

class InfoWarningBox extends StatelessWidget {
  const InfoWarningBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 212, 182).withOpacity(0.56),
      ),
      child: Row(
        children: [
          Image.asset(Assets.assetsImagesWarning),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              'Your account will be under review by admin. You will be notified once approved.',
              style: GoogleFonts.archivo(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
