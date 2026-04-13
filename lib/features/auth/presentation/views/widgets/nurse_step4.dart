import 'package:flutter/material.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/review_row.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class NurseStep4 extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String serviceType;
  final String licenseNumber;
  final String experience;
  final List<String> serviceAreas;
  final String? uploadedFileName;

  const NurseStep4({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.serviceType,
    required this.licenseNumber,
    required this.experience,
    required this.serviceAreas,
    required this.uploadedFileName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Personal Details ──────────────────
        StepCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.reviewYourInformation, style: textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(
                l10n.personalDetails,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ReviewRow(label: l10n.name, value: fullName),
              ReviewRow(label: l10n.email, value: email),
              ReviewRow(label: l10n.phone, value: phone),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Professional Details ──────────────
        StepCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.professionalDetails,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ReviewRow(label: '${l10n.serviceType}:', value: serviceType),
              ReviewRow(label: l10n.licenseNumber, value: licenseNumber),
              ReviewRow(label: l10n.experience, value: '$experience years'),

              // ── Service Areas Chips ────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        '${l10n.serviceAreasLabel}:',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            serviceAreas
                                .map(
                                  (area) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary.withOpacity(
                                        0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: colorScheme.secondary
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                    child: Text(
                                      area,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Terms ─────────────────────────────
        StepCard(
          color: colorScheme.primaryContainer,
          child: RichText(
            text: TextSpan(
              style: textTheme.bodySmall,
              children: [
                TextSpan(text: l10n.bySubmittingThis),
                TextSpan(
                  text: l10n.termsOfService,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: l10n.privacyPolicy,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
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
