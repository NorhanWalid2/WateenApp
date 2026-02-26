import 'package:flutter/material.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Personal Information Section ────────
          _SectionHeader(title: 'Personal Information'),
          const SizedBox(height: 16),

          // Full Name
          _FormField(
            controller: _fullNameController,
            label: 'Full Name *',
            hint: 'Enter your full name',
          ),
          const SizedBox(height: 14),

          // Email
          _FormField(
            controller: _emailController,
            label: 'Email Address *',
            hint: 'you@email@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),

          // Password
          _FormField(
            controller: _passwordController,
            label: 'Password *',
            hint: 'Create a password',
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 14),

          // Confirm Password
          _FormField(
            controller: _confirmPasswordController,
            label: 'Confirm Password *',
            hint: 'Confirm your password',
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed:
                  () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 14),

          // Phone Number
          _FormField(
            controller: _phoneController,
            label: 'Phone Number *',
            hint: '+966 5x xxx xxxx',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),

          // Date of Birth + Gender (Row)
          Row(
            children: [
              Expanded(
                child: _FormField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  hint: 'DD/MM/YYYY',
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
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
          const SizedBox(height: 14),

          // National ID
          _FormField(
            controller: _nationalIdController,
            label: 'National ID',
            hint: 'Enter your national ID',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),

          // Blood Type
          _DropdownField(
            label: 'Blood Type',
            hint: 'Select blood type',
            value: _selectedBloodType,
            items: _bloodTypes,
            onChanged: (v) => setState(() => _selectedBloodType = v),
          ),

          const SizedBox(height: 28),

          // ── Emergency Contact Section ────────────
          _SectionHeader(title: 'Emergency Contact'),
          const SizedBox(height: 16),

          // Contact Name
          _FormField(
            controller: _contactNameController,
            label: 'Contact Name',
            hint: 'Full name of emergency contact',
          ),
          const SizedBox(height: 14),

          // Contact Phone
          _FormField(
            controller: _contactPhoneController,
            label: 'Contact Phone',
            hint: '+966 5x xxx xxxx',
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 28),

          // ── Terms of Service ─────────────────────
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'By creating an account, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Submit Button ────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: submit
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create Patient Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Reusable Widgets
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Divider(color: colorScheme.outline, thickness: 1),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
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
          decoration: const InputDecoration(),
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
