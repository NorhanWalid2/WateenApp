import 'package:flutter/material.dart';
import 'package:wateen_app/features/onboarding/data/models/model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Image ───────────────────────────
          Image.asset(
            model.image,
            fit: BoxFit.contain,
            width: 192,
            height: 192,
          ),

          // ── Title ───────────────────────────
          Text(
            model.title,
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // ── Description ─────────────────────
          Text(
            model.description,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
