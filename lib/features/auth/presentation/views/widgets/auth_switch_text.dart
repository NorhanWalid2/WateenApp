
import 'package:flutter/material.dart';

class AuthSwitchText extends StatelessWidget {
  const AuthSwitchText({
    super.key,
    required this.colorScheme,
    required this.firstText,
    required this.secondText,
  });

  final ColorScheme colorScheme;
  final String firstText;
  final String secondText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: firstText,
          style: TextStyle(fontSize: 13, color: colorScheme.outlineVariant),
          children: [
            TextSpan(
              text: secondText,
              style: TextStyle(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
