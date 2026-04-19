import 'package:flutter/material.dart';

class SettingsInfoItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final Color? valueColor;

  const SettingsInfoItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ],
      ),
    );
  }
}
