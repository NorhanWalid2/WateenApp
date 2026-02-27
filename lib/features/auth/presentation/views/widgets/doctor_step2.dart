import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StepCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.professionalInformation,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CustomTextFormFieldWidget(
              title: AppStrings.specialization,
              hintText: 'e.g., Cardiology',
              controller: specializationController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.medicalLicenseNumber,
              hintText: AppStrings.enterLicenseNumber,
              controller: licenseNumberController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.yearsofExperience,
              hintText: 'e.g., 5',
              controller: experienceController,
              myValidator: Validator.validateName,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.hospitalClinicAffiliation,
              hintText: AppStrings.currentWorkplace,
              controller: hospitalController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.consultationFee,
              hintText: 'e.g., 200',
              controller: consultationFeeController,
              myValidator: (_) => null,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
