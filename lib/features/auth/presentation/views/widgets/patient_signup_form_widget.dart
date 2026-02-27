import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';

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

  final List<String> _genders = ['Male', 'Female'];
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 21),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: colorScheme.primary,
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
                Text(
                  AppStrings.personalInformation,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.fullName,
                  hintText: AppStrings.enteryourfullname,
                  controller: _fullNameController,
                  myValidator: Validator.validateName,
                ),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.emailAddress,
                  hintText: AppStrings.youremailexample,
                  controller: _emailController,
                  myValidator: Validator.validateName,
                ),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.password,
                  hintText: AppStrings.enteryourpassword,
                  controller: _passwordController,
                  myValidator: Validator.validatePassword,
                  isPassword: true,
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.confirmPassword,
                  hintText: AppStrings.confirmyourpassword,
                  controller: _confirmPasswordController,
                  myValidator: Validator.validatePassword,
                  isPassword: true,
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.phoneNumber,
                  hintText: AppStrings.numberExample,
                  controller: _phoneController,
                  myValidator: Validator.validatePhoneNumber,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormFieldWidget(
                        title: AppStrings.dateofBirth,
                        hintText: 'DD/MM/YYYY',
                        controller: _dobController,
                        readOrNot: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary, // لون الـ selected day (أحمر)
                                    onPrimary: Colors.white, // نص فوق الأحمر
                                    surface: Colors.white, // خلفية الـ dialog
                                    onSurface:
                                        Colors.black87, // لون الأرقام والنصوص
                                  ),
                                  dialogTheme: DialogThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
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
                        label: 'Gender',
                        hint: 'Gender',
                        value: _selectedGender,
                        items: _genders,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _DropdownField(
                  label: 'Blood Type',
                  hint: 'Select blood type',
                  value: _selectedBloodType,
                  items: _bloodTypes,
                  onChanged: (v) => setState(() => _selectedBloodType = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 21),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: colorScheme.primary,
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
                Text(AppStrings.emergencyContact, style: textTheme.titleLarge),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.contactName,
                  hintText: AppStrings.fullnameofemergencycontact,
                  controller: _contactNameController,
                  myValidator: Validator.validateName,
                ),
                const SizedBox(height: 15),
                CustomTextFormFieldWidget(
                  title: AppStrings.contactPhone,
                  hintText: AppStrings.numberExample,
                  controller: _contactPhoneController,
                  myValidator: Validator.validatePhoneNumber,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 21),
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
                    text: AppStrings.termsOfService,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: AppStrings.byCreatingAnAccount,
                    style: textTheme.titleSmall,
                  ),
                  TextSpan(
                    text: AppStrings.privacyPolicy,
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
          CustomButton(
            title: AppStrings.createPatientAccount,
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
