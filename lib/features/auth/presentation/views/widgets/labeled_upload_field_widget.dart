import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/utls/app_assets.dart';

class LabeledUploadFieldWidget extends StatelessWidget {
  const LabeledUploadFieldWidget({
    super.key,
    required this.title,
    required this.document,
    required this.subtitle,
  });
  final String title;
  final String document;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.heebo(
            fontSize: 20,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorScheme.surface,
          ),
          child: ListTile(
            leading: Image.asset(Assets.assetsImagesLicense),
            title: Text(
              document,
              style: GoogleFonts.archivo(
                fontSize: 18,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: textTheme.bodyMedium,
            ),
            trailing: Image.asset(Assets.assetsImagesUpload),
          ),
        ),
      ],
    );
  }
}