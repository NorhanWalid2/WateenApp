import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_step1.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_step2.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_step4.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_progress_bar.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class DoctorSignUpFormWidget extends StatefulWidget {
  const DoctorSignUpFormWidget({super.key});

  @override
  State<DoctorSignUpFormWidget> createState() => _DoctorSignUpFormWidgetState();
}

class _DoctorSignUpFormWidgetState extends State<DoctorSignUpFormWidget> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  // ── Step 1 ───────────────────────────────────
  final _step1Key = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── Step 2 ───────────────────────────────────
  final _step2Key = GlobalKey<FormState>();
  final _specializationController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  bool _homeVisits = false;

  // ── Step 3 ───────────────────────────────────
  String? _uploadedFileName;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _hospitalController.dispose();
    _consultationFeeController.dispose();
    super.dispose();
  }

  Future<void> _onBackPressed() async {
    if (_currentStep == 0) return;
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(l10n.goBack),
            content: Text(l10n.goBackContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  l10n.goBack,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) setState(() => _currentStep--);
  }

  void _onContinue() {
    switch (_currentStep) {
      case 0:
        if (_step1Key.currentState!.validate()) setState(() => _currentStep++);
        break;
      case 1:
        if (_step2Key.currentState!.validate()) setState(() => _currentStep++);
        break;

     case 2:
        context.read<AuthCubit>().registerDoctor(
          fullName:        _fullNameController.text.trim(),
          email:           _emailController.text.trim(),
          phone:           _phoneController.text.trim(),
          password:        _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          specialization:  _specializationController.text.trim(),
          licenseNumber:   _licenseNumberController.text.trim(),
          workPlace:       _hospitalController.text.trim(),   // ✅ was bio
          experienceYears: _experienceController.text.trim(), // ✅ was missing
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBackPressed();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.step} ${_currentStep + 1} of $_totalSteps',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          StepProgressBar(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            activeColor: colorScheme.secondary,
            inactiveColor: colorScheme.outline,
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder:
                (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
            child: KeyedSubtree(
              key: ValueKey(_currentStep),
              child: _buildCurrentStep(),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            title:
                _currentStep == _totalSteps - 1
                    ? l10n.submitRegistration
                    : l10n.continue_,
            color: colorScheme.secondary,
            colorText: colorScheme.primary,
            onTap: _onContinue,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return DoctorStep1(
          formKey: _step1Key,
          fullNameController: _fullNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        );
      case 1:
        return DoctorStep2(
          formKey: _step2Key,
          specializationController: _specializationController,
          licenseNumberController: _licenseNumberController,
          experienceController: _experienceController,
          hospitalController: _hospitalController,
          consultationFeeController: _consultationFeeController,
          homeVisits: _homeVisits,
          onHomeVisitsChanged: (v) => setState(() => _homeVisits = v),
        );

      case 2:
        return DoctorStep4(
          fullName: _fullNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          specialization: _specializationController.text,
          licenseNumber: _licenseNumberController.text,
          experience: _experienceController.text,
          hospital: _hospitalController.text,
          homeVisits: _homeVisits,
          uploadedFileName: _uploadedFileName,
        );
      default:
        return const SizedBox();
    }
  }
}
