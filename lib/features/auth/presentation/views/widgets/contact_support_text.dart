import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ContactSupportText extends StatelessWidget {
  const ContactSupportText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Need help? ',
          style: const TextStyle(color: Colors.black, fontSize: 13),
          children: [
            TextSpan(
              text: 'Contact Support',
              style: const TextStyle(
                color: Color(0xFFE00000),
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
