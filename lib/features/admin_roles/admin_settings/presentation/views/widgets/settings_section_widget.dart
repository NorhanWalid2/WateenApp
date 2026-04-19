import 'package:flutter/material.dart';

class SettingsSectionWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Title ──
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            color: Theme.of(context).colorScheme.surface,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 8),

          // ── Children ──
          ...children,
        ],
      ),
    );
  }
}
