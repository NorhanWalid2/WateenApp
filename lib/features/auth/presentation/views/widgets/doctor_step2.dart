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
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return StepCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.professionalInformation, style: textTheme.titleLarge),
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
              myValidator: Validator.validateName,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: l10n.hospitalClinicAffiliation,
              hintText: l10n.currentWorkplace,
              controller: hospitalController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
