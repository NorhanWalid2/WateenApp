import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/function/toast_message.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/drop_down_field.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class PatientSignupFormWidget extends StatefulWidget {
  const PatientSignupFormWidget({super.key});

  @override
  State<PatientSignupFormWidget> createState() =>
      _PatientSignupFormWidgetState();
}

class _PatientSignupFormWidgetState extends State<PatientSignupFormWidget> {
  // ── Cubit ─────────────────────────────────────
  late final AuthCubit _authCubit;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodType;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
  }

  @override
  void dispose() {
    _authCubit.close();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _nationalIdController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // ✅ Validate date picked
      if (_dobController.text.isEmpty) {
        showToastMessage(
          context,
          'Please select your date of birth',
          ToastType.error,
        );
        return;
      }

      // ✅ Validate gender selected
      if (_selectedGender == null) {
        showToastMessage(context, 'Please select your gender', ToastType.error);
        return;
      }

      _authCubit.registerPatient(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        gender: _selectedGender!,
        dateOfBirth: _dobController.text,
        phoneNumber: _phoneController.text.trim(), // ✅ added
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final genders = [l10n.male, l10n.female];

    final cardDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: colorScheme.primary,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    return BlocProvider.value(
      value: _authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            showToastMessage(context, l10n.registerSuccess, ToastType.success);
            CustomReplacementNavigation(context, '/login');
          } else if (state is AuthFailure) {
            final msg =
                state.message == 'errorGeneral'
                    ? l10n.errorGeneral
                    : state.message;
            showToastMessage(context, msg, ToastType.error);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // ── Personal Information ──────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: 21,
                  ),
                  width: double.infinity,
                  decoration: cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.personalInformation,
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.fullName,
                        hintText: l10n.enteryourfullname,
                        controller: _fullNameController,
                        myValidator: Validator.validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.emailAddress,
                        hintText: l10n.youremailexample,
                        controller: _emailController,
                        myValidator: Validator.validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.password,
                        hintText: l10n.enteryourpassword,
                        controller: _passwordController,
                        myValidator: Validator.validatePassword,
                        isPassword: true,
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.confirmPassword,
                        hintText: l10n.confirmyourpassword,
                        controller: _confirmPasswordController,
                        myValidator: Validator.validatePassword,
                        isPassword: true,
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.phoneNumber,
                        hintText: l10n.numberExample,
                        controller: _phoneController,
                        myValidator: Validator.validatePhoneNumber,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormFieldWidget(
                              title: l10n.dateofBirth,
                              hintText: 'DD/MM/YYYY',
                              controller: _dobController,
                              readOrNot: true,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder:
                                      (context, child) => Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black87,
                                          ),
                                          dialogTheme: DialogThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                );
                                if (picked != null) {
                                  _dobController.text =
                                      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownField(
                              label: l10n.gender,
                              hint: l10n.gender,
                              value: _selectedGender,
                              items: genders,
                              onChanged:
                                  (v) => setState(() => _selectedGender = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        label: l10n.bloodType,
                        hint: l10n.selectBloodType,
                        value: _selectedBloodType,
                        items: _bloodTypes,
                        onChanged:
                            (v) => setState(() => _selectedBloodType = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Emergency Contact ─────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: 21,
                  ),
                  width: double.infinity,
                  decoration: cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.emergencyContact, style: textTheme.titleLarge),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.contactName,
                        hintText: l10n.fullnameofemergencycontact,
                        controller: _contactNameController,
                        myValidator: Validator.validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormFieldWidget(
                        title: l10n.contactPhone,
                        hintText: l10n.numberExample,
                        controller: _contactPhoneController,
                        myValidator: Validator.validatePhoneNumber,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Terms ─────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: 21,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.termsOfService,
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: l10n.byCreatingAnAccount,
                          style: textTheme.titleSmall,
                        ),
                        TextSpan(
                          text: l10n.privacyPolicy,
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Submit Button ─────────────────────
                state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                      title: l10n.createPatientAccount,
                      color: colorScheme.secondary,
                      colorText: colorScheme.primary,
                      onTap: _submit,
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
