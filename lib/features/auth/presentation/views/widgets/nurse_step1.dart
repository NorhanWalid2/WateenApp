import 'package:flutter/material.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';

class NurseStep1 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const NurseStep1({
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
            Text('Basic Information', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            CustomTextFormFieldWidget(
              title: 'Full Name *',
              hintText: 'Your full name',
              controller: fullNameController,
              myValidator: Validator.validateName,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: 'Email Address *',
              hintText: 'your.email@example.com',
              controller: emailController,
              myValidator: Validator.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: 'Phone Number *',
              hintText: '+966 5x xxx xxxx',
              controller: phoneController,
              myValidator: Validator.validatePhoneNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: 'Password *',
              hintText: 'Create a secure password',
              controller: passwordController,
              myValidator: Validator.validatePassword,
              isPassword: true,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            CustomTextFormFieldWidget(
              title: 'Confirm Password *',
              hintText: 'Confirm your password',
              controller: confirmPasswordController,
              myValidator: (val) => Validator.validateConfirmPassword(
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