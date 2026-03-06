import 'package:flutter/material.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;

  const SettingsSectionWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      title.toUpperCase(),
      style: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}