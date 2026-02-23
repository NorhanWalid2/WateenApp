import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/utls/app_assets.dart';

class InfoWarningBox extends StatelessWidget {
  const InfoWarningBox({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // tertiary في الـ theme هو accent = softRed/lightPastelPink — مناسب للـ warning
        color: colorScheme.tertiary.withOpacity(0.25),
      ),
      child: Row(
        children: [
          Image.asset(Assets.assetsImagesWarning),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              'Your account will be under review by admin. You will be notified once approved.',
              style: GoogleFonts.archivo(
                fontSize: 15,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}