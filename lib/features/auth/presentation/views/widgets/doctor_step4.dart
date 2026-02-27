import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/review_row.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Personal Details ───────────────
        StepCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.reviewYourInformation,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(AppStrings.personalDetails, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ReviewRow(label: AppStrings.name, value: fullName),
                    ReviewRow(label: AppStrings.email, value: email),
                    ReviewRow(label: AppStrings.phone, value: phone),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.professionalDetails,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ReviewRow(
                      label: AppStrings.specialization + ':',
                      value: specialization,
                    ),
                    ReviewRow(
                      label: AppStrings.licenseNumber,
                      value: licenseNumber,
                    ),
                    ReviewRow(
                      label: AppStrings.experience,
                      value: '$experience years',
                    ),
                    ReviewRow(label: AppStrings.hospital, value: hospital),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(AppStrings.licenseStatus, style: textTheme.titleMedium),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      uploadedFileName != null
                          ? AppStrings.licenseVerified
                          : AppStrings.noLicenseUploaded,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
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
                TextSpan(text: AppStrings.bySubmittingThis),
                TextSpan(
                  text: AppStrings.termsOfService,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: AppStrings.privacyPolicy,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
