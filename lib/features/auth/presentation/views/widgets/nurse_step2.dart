import 'package:flutter/material.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';

class NurseStep2 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? selectedServiceType;
  final ValueChanged<String?> onServiceTypeChanged;
  final TextEditingController licenseNumberController;
  final TextEditingController experienceController;
  final TextEditingController hourlyRateController;
  final List<String> selectedAreas;
  final ValueChanged<String> onAreaToggled;

  const NurseStep2({
    super.key,
    required this.formKey,
    required this.selectedServiceType,
    required this.onServiceTypeChanged,
    required this.licenseNumberController,
    required this.experienceController,
    required this.hourlyRateController,
    required this.selectedAreas,
    required this.onAreaToggled,
  });

  static const List<String> _serviceTypes = [
    'Licensed Practical Nurse',
    'Registered Nurse',
    'Physiotherapist',
    'Home Health Aide',
    'Caregiver',
  ];

  static const List<String> _serviceAreas = [
    'Riyadh - North',
    'Riyadh - South',
    'Riyadh - East',
    'Riyadh - West',
    'Jeddah - North',
    'Jeddah - South',
    'Dammam',
    'Khobar',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StepCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Professional Information', style: textTheme.titleLarge),
            const SizedBox(height: 16),

            // ── Service Type Dropdown ────────────
            Text(
              'Service Type *',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedServiceType,
              hint: Text(
                'Select your service type',
                style: TextStyle(
                    fontSize: 14, color: colorScheme.onSurfaceVariant),
              ),
              items: _serviceTypes
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: onServiceTypeChanged,
              validator: (val) =>
                  val == null ? 'Please select a service type' : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: colorScheme.outline, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: colorScheme.secondary, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: colorScheme.error, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 14),

            // ── License Number ───────────────────
            CustomTextFormFieldWidget(
              title: 'License/Certification Number *',
              hintText: 'Enter license number',
              controller: licenseNumberController,
              myValidator: Validator.validateName,
            ),

            const SizedBox(height: 14),

            // ── Years of Experience ──────────────
            CustomTextFormFieldWidget(
              title: 'Years of Experience *',
              hintText: 'e.g., 3',
              controller: experienceController,
              myValidator: Validator.validateName,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 14),

            // ── Hourly Rate ──────────────────────
            CustomTextFormFieldWidget(
              title: 'Hourly Rate (SAR)',
              hintText: 'e.g., 150',
              controller: hourlyRateController,
              myValidator: (_) => null,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // ── Service Areas ────────────────────
            Text(
              'Service Areas * (Select at least one)',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _serviceAreas.map((area) {
                final isSelected = selectedAreas.contains(area);
                return GestureDetector(
                  onTap: () => onAreaToggled(area),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.secondary.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.secondary
                            : colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      area,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.secondary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // ── Validation Message ───────────────
            if (selectedAreas.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Please select at least one area',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}