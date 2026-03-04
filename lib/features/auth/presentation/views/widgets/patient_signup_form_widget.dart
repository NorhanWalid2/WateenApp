import 'package:flutter/material.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class PatientSignupFormWidget extends StatefulWidget {
  const PatientSignupFormWidget({super.key});

  @override
  State<PatientSignupFormWidget> createState() =>
      _PatientSignupFormWidgetState();
}

class _PatientSignupFormWidgetState extends State<PatientSignupFormWidget> {
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
  void dispose() {
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

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Personal Information ──────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
            width: double.infinity,
            decoration: cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.personalInformation, style: textTheme.titleLarge),
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
                                        borderRadius: BorderRadius.circular(16),
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
                      child: _DropdownField(
                        label: l10n.gender,
                        hint: l10n.gender,
                        value: _selectedGender,
                        items: genders,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _DropdownField(
                  label: l10n.bloodType,
                  hint: l10n.selectBloodType,
                  value: _selectedBloodType,
                  items: _bloodTypes,
                  onChanged: (v) => setState(() => _selectedBloodType = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Emergency Contact ─────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
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
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
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
          CustomButton(
            title: l10n.createPatientAccount,
            color: colorScheme.secondary,
            colorText: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 14)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.onTertiary, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          dropdownColor: colorScheme.surface,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
