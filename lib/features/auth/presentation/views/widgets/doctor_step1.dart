import 'package:flutter/material.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class DoctorStep1 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const DoctorStep1({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
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
            Text(l10n.basicInformation, style: textTheme.titleLarge),
            const SizedBox(height: 16),
            CustomTextFormFieldWidget(
              title: l10n.fullName,
              hintText: l10n.drFullName,
              controller: fullNameController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: l10n.emailAddress,
              hintText: l10n.doctorHospital,
              controller: emailController,
              myValidator: Validator.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: l10n.phoneNumber,
              hintText: l10n.numberExample,
              controller: phoneController,
              myValidator: Validator.validatePhoneNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: l10n.password,
              hintText: l10n.createSecurePassword,
              controller: passwordController,
              myValidator: Validator.validatePassword,
              isPassword: true,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: l10n.confirmPassword,
              hintText: l10n.confirmPassword,
              controller: confirmPasswordController,
              myValidator:
                  (val) => Validator.validateConfirmPassword(
                    val,
                    passwordController.text,
                  ),
              isPassword: true,
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}
