import 'package:flutter/material.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class DoctorStep2 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController specializationController;
  final TextEditingController licenseNumberController;
  final TextEditingController experienceController;
  final TextEditingController hospitalController;
  final TextEditingController consultationFeeController;

  final bool homeVisits;
  final ValueChanged<bool> onHomeVisitsChanged;

  final String? selectedLocation;
  final ValueChanged<String?> onLocationChanged;

  const DoctorStep2({
    super.key,
    required this.formKey,
    required this.specializationController,
    required this.licenseNumberController,
    required this.experienceController,
    required this.hospitalController,
    required this.consultationFeeController,
    required this.homeVisits,
    required this.onHomeVisitsChanged,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final locations = [
      'Cairo',
      'Giza',
      'Alexandria',
      'Dakahlia',
      'Sharqia',
      'Gharbia',
      'Monufia',
      'Qalyubia',
      'Fayoum',
      'Beni Suef',
      'Minya',
      'Assiut',
      'Sohag',
      'Qena',
      'Luxor',
      'Aswan',
      'Red Sea',
      'Ismailia',
      'Port Said',
      'Suez',
    ];

    return StepCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.professionalInformation,
              style: textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            CustomTextFormFieldWidget(
              title: l10n.specialization,
              hintText: 'e.g., Cardiology',
              controller: specializationController,
              myValidator: Validator.validateName,
            ),

            const SizedBox(height: 14),

            CustomTextFormFieldWidget(
              title: l10n.medicalLicenseNumber,
              hintText: l10n.enterLicenseNumber,
              controller: licenseNumberController,
              myValidator: Validator.validateName,
            ),

            const SizedBox(height: 14),

            CustomTextFormFieldWidget(
              title: l10n.yearsofExperience,
              hintText: 'e.g., 5',
              controller: experienceController,
              keyboardType: TextInputType.number,
              myValidator: Validator.validateName,
            ),

            const SizedBox(height: 14),

            CustomTextFormFieldWidget(
              title: l10n.hospitalClinicAffiliation,
              hintText: l10n.currentWorkplace,
              controller: hospitalController,
              myValidator: Validator.validateName,
            ),

            const SizedBox(height: 14),

            Text(
              'Location',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedLocation,
              decoration: InputDecoration(
                hintText: 'Select your location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: onLocationChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a location';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}