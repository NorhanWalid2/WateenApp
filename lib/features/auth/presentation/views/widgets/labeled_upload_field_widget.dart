
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.heebo(fontSize: 20)),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 241, 234, 234),
          ),
          child: ListTile(
            leading: Image.asset(Assets.assetsImagesLicense),
            title: Text(
              document,
              style: GoogleFonts.archivo(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(subtitle),
            trailing: Image.asset(Assets.assetsImagesUpload),
          ),
        ),
      ],
    );
  }
}
