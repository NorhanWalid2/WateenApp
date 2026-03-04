import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';

class ContactSupportText extends StatelessWidget {
  const ContactSupportText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '${AppStrings.needHelp} ',
          style: AppTextstyle.archivo15w400Gray(context),
          children: [
            TextSpan(
              text: AppStrings.contactSupport,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: open support
                    },
            ),
          ],
        ),
      ),
    );
  }
}
