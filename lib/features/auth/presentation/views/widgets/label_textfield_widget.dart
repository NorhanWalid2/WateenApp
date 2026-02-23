import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/text_form_field_widget.dart';

class LabeledTextFieldWidget extends StatelessWidget {
  const LabeledTextFieldWidget({
    super.key,
    required this.icon,
    required this.hintText, required this.title,
  });
  final Widget icon;
  final String hintText;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.heebo(fontSize: 20)),
        const SizedBox(height: 10),
        TextFormFieldWidget(
          icon: icon,
          hintText: hintText,
        ),
      ],
    );
  }
}
