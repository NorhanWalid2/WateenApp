import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';

class ForgetPasswordFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSend;
  final bool isLoading;

  const ForgetPasswordFormWidget({
    super.key,
    required this.emailController,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Form Card ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Uses your CustomTextFormFieldWidget with controller bound
              CustomTextFormFieldWidget(
                title: AppStrings.emailAddress,
                hintText: AppStrings.enteryouremail,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                myValidator: Validator.validateEmail,
              ),

              const SizedBox(height: 20),

              // Send button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : Text(
                            AppStrings.sendVerificationCode,
                            style: AppTextstyle.arimo16(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Info Box ───────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: colorScheme.secondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.theVerificationCode,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.secondary,
                    height: 1.5,
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
