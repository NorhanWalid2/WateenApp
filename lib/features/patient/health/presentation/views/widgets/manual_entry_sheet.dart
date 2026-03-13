import 'package:flutter/material.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/health/data/models/vital_type_model.dart';

class ManualEntrySheet extends StatefulWidget {
  final List<VitalTypeModel> vitals;
  final void Function(
    VitalType type,
    double value,
    double? secondValue,
    String notes,
  )
  onSubmit;

  const ManualEntrySheet({
    super.key,
    required this.vitals,
    required this.onSubmit,
  });

  @override
  State<ManualEntrySheet> createState() => ManualEntrySheetState();
}

class ManualEntrySheetState extends State<ManualEntrySheet> {
  VitalType? selectedType;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController secondValueController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool get isBloodPressure => selectedType == VitalType.bloodPressure;

  VitalTypeModel? get selectedVital =>
      selectedType == null
          ? null
          : widget.vitals.firstWhere((v) => v.type == selectedType);

  @override
  void dispose() {
    valueController.dispose();
    secondValueController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void submit() {
    if (selectedType == null || valueController.text.isEmpty) return;
    final value = double.tryParse(valueController.text);
    if (value == null) return;
    final secondValue =
        isBloodPressure ? double.tryParse(secondValueController.text) : null;
    widget.onSubmit(selectedType!, value, secondValue, notesController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // ✅ استخدام surface بدل background
    final sheetColor = colorScheme.surface;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.manualEntry,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.selectVitalType,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<VitalType>(
                  isExpanded: true,
                  value: selectedType,
                  dropdownColor: colorScheme.surface,
                  hint: Text(
                    l10n.selectVitalType,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  items:
                      widget.vitals
                          .map(
                            (v) => DropdownMenuItem(
                              value: v.type,
                              child: Row(
                                children: [
                                  Icon(v.icon, color: v.color, size: 18),
                                  const SizedBox(width: 8),
                                  Text(v.label),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => selectedType = v),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (selectedType != null) ...[
              if (isBloodPressure) ...[
                Row(
                  children: [
                    Expanded(
                      child: _InputField(
                        controller: valueController,
                        label: 'Systolic',
                        hint: '120',
                        unit: 'mmHg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InputField(
                        controller: secondValueController,
                        label: 'Diastolic',
                        hint: '80',
                        unit: 'mmHg',
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _InputField(
                  controller: valueController,
                  label: selectedVital!.label,
                  hint: '',
                  unit: selectedVital!.unit,
                ),
              ],
              const SizedBox(height: 16),

              Text(
                l10n.notesOptional,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: TextField(
                  controller: notesController,
                  maxLines: 3,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: l10n.addNotes,
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedType != null ? submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.submit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String unit;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.unit,
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
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              suffixText: unit,
              suffixStyle: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
