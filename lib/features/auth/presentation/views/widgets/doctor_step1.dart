import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return StepCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.basicInformation, style: textTheme.titleLarge),
            const SizedBox(height: 16),
            CustomTextFormFieldWidget(
              title: AppStrings.fullName,
              hintText: AppStrings.drFullName,
              controller: fullNameController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.emailAddress,
              hintText: AppStrings.doctorHospital,
              controller: emailController,
              myValidator: Validator.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.phoneNumber,
              hintText: AppStrings.numberExample,
              controller: phoneController,
              myValidator: Validator.validatePhoneNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.password,
              hintText: AppStrings.createSecurePassword,
              controller: passwordController,
              myValidator: Validator.validatePassword,
              isPassword: true,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: AppStrings.confirmPassword,
              hintText: AppStrings.confirmPassword,
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
