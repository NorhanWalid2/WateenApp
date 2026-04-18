import 'package:flutter/material.dart';

class ProfileSheetFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final Widget? trailing;

  const ProfileSheetFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: textTheme.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.inverseSurface),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: trailing!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}