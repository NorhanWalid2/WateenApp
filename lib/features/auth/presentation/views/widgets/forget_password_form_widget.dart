import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/text_form_field_widget.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Form Card ──
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email label
              Text(
                AppStrings.emailAddress,
                style: AppTextstyle.arimo16(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Email field using existing widget
              TextFormFieldWidget(
                icon: Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                hintText: AppStrings.enteryouremail,
              ),

              const SizedBox(height: 20),

              // Send button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
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

        // ── Warning Info Box ──
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.secondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.theVerificationCode,
                  style: AppTextstyle.archivo15w400Gray(context).copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
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
