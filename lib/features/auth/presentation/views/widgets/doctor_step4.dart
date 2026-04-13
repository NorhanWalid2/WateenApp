import 'package:flutter/material.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/review_row.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class DoctorStep4 extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String specialization;
  final String licenseNumber;
  final String experience;
  final String hospital;
  final bool homeVisits;
  final String? uploadedFileName;

  const DoctorStep4({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.licenseNumber,
    required this.experience,
    required this.hospital,
    required this.homeVisits,
    required this.uploadedFileName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final reviewBg = BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
    );

    return Column(
      children: [
        // ── Personal + Professional Details ───
        StepCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.reviewYourInformation, style: textTheme.titleLarge),
              const SizedBox(height: 16),

              Text(l10n.personalDetails, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: reviewBg,
                child: Column(
                  children: [
                    ReviewRow(label: l10n.name, value: fullName),
                    ReviewRow(label: l10n.email, value: email),
                    ReviewRow(label: l10n.phone, value: phone),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(l10n.professionalDetails, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: reviewBg,
                child: Column(
                  children: [
                    ReviewRow(
                      label: '${l10n.specialization}:',
                      value: specialization,
                    ),
                    ReviewRow(label: l10n.licenseNumber, value: licenseNumber),
                    ReviewRow(
                      label: l10n.experience,
                      value: '$experience years',
                    ),
                    ReviewRow(label: l10n.hospital, value: hospital),
                  ],
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Terms ──────────────────────────
        StepCard(
          color: colorScheme.primaryContainer,
          child: RichText(
            text: TextSpan(
              style: textTheme.titleSmall,
              children: [
                TextSpan(text: l10n.bySubmittingThis),
                TextSpan(
                  text: l10n.termsOfService,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: l10n.privacyPolicy,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.tertiary),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📋 ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  l10n.yourAccountWillBe,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
