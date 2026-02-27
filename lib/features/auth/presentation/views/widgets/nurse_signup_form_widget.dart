import 'package:flutter/material.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_step1.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_step3.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/nurse_step1.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/nurse_step2.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/nurse_step4.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_progress_bar.dart';

class NurseSignupFormWidget extends StatefulWidget {
  const NurseSignupFormWidget({super.key});

  @override
  State<NurseSignupFormWidget> createState() => _NurseSignupFormWidgetState();
}

class _NurseSignupFormWidgetState extends State<NurseSignupFormWidget> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  // ── Step 1 ───────────────────────────────────
  final _step1Key = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── Step 2 ───────────────────────────────────
  final _step2Key = GlobalKey<FormState>();
  String? _selectedServiceType;
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final List<String> _selectedAreas = [];

  // ── Step 3 ───────────────────────────────────
  String? _uploadedFileName;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  // ── Back with Confirm Dialog ──────────────────
  Future<void> _onBackPressed() async {
    if (_currentStep == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Go Back?'),
            content: const Text(
              'Are you sure you want to go back? Your progress in this step will be kept.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Go Back',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) setState(() => _currentStep--);
  }

  // ── Continue / Submit ─────────────────────────
  void _onContinue() {
    switch (_currentStep) {
      case 0:
        if (_step1Key.currentState!.validate()) setState(() => _currentStep++);
        break;
      case 1:
        if (_step2Key.currentState!.validate() && _selectedAreas.isNotEmpty) {
          setState(() => _currentStep++);
        } else {
          setState(() {}); // trigger rebuild to show areas error
        }
        break;
      case 2:
        setState(() => _currentStep++);
        break;
      case 3:
        // TODO: Submit
        break;
    }
  }

  // ── Toggle Service Area ───────────────────────
  void _toggleArea(String area) {
    setState(() {
      if (_selectedAreas.contains(area)) {
        _selectedAreas.remove(area);
      } else {
        _selectedAreas.add(area);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // ── Step Label ───────────────────────
          Text(
            'Step ${_currentStep + 1} of $_totalSteps',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),

          // ── Progress Bar ─────────────────────
          StepProgressBar(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            activeColor: colorScheme.secondary,
            inactiveColor: colorScheme.outline,
          ),

          const SizedBox(height: 24),

          // ── Animated Step Content ────────────
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

          // ── Button ───────────────────────────
          CustomButton(
            title:
                _currentStep == _totalSteps - 1
                    ? 'Submit Registration'
                    : 'Continue',
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
        // ✅ بنستخدم DoctorStep1 لأنه نفس البيانات بالظبط
        return NurseStep1(
          formKey: _step1Key,
          fullNameController: _fullNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        );
      case 1:
        return NurseStep2(
          formKey: _step2Key,
          selectedServiceType: _selectedServiceType,
          onServiceTypeChanged: (v) => setState(() => _selectedServiceType = v),
          licenseNumberController: _licenseNumberController,
          experienceController: _experienceController,
          hourlyRateController: _hourlyRateController,
          selectedAreas: _selectedAreas,
          onAreaToggled: _toggleArea,
        );
      case 2:
        // ✅ بنستخدم DoctorStep3 لأنه نفس الـ upload
        return DoctorStep3(
          uploadedFileName: _uploadedFileName,
          onFileUploaded: (name) => setState(() => _uploadedFileName = name),
        );
      case 3:
        return NurseStep4(
          fullName: _fullNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          serviceType: _selectedServiceType ?? '',
          licenseNumber: _licenseNumberController.text,
          experience: _experienceController.text,
          serviceAreas: _selectedAreas,
          uploadedFileName: _uploadedFileName,
        );
      default:
        return const SizedBox();
    }
  }
}
