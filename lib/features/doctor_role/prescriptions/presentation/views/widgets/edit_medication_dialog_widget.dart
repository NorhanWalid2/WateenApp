import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/data/prescription_model.dart';
import 'medication_form_helpers.dart';

class EditMedicationDialogWidget extends StatefulWidget {
  final PrescriptionModel prescription;
  final Function(PrescriptionModel) onSave;

  const EditMedicationDialogWidget({
    super.key,
    required this.prescription,
    required this.onSave,
  });

  @override
  State<EditMedicationDialogWidget> createState() =>
      _EditMedicationDialogWidgetState();
}

class _EditMedicationDialogWidgetState
    extends State<EditMedicationDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _instructionsController;
  late String _frequency;
  late String _duration;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.prescription.medicationName);
    _dosageController =
        TextEditingController(text: widget.prescription.dosage);
    _instructionsController =
        TextEditingController(text: widget.prescription.instructions);
    _frequency = widget.prescription.frequency;
    _duration = widget.prescription.duration;
    _startDate = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // ── Title ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Medication',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Medication Name ──
              const MedicationFieldLabel(label: 'Medication Name'),
              const SizedBox(height: 6),
              MedicationInputField(
                controller: _nameController,
                hint: 'Enter medication name',
                validator: (v) =>
                    v!.isEmpty ? 'Please enter medication name' : null,
              ),

              const SizedBox(height: 14),

              // ── Dosage ──
              const MedicationFieldLabel(label: 'Dosage'),
              const SizedBox(height: 6),
              MedicationInputField(
                controller: _dosageController,
                hint: 'e.g., 10mg, 500mg',
                validator: (v) =>
                    v!.isEmpty ? 'Please enter dosage' : null,
              ),

              const SizedBox(height: 14),

              // ── Frequency ──
              const MedicationFieldLabel(label: 'Frequency'),
              const SizedBox(height: 6),
              MedicationDropdownField(
                value: _frequency,
                items: PrescriptionModel.frequencyOptions,
                onChanged: (val) => setState(() => _frequency = val!),
              ),

              const SizedBox(height: 14),

              // ── Duration ──
              const MedicationFieldLabel(label: 'Duration'),
              const SizedBox(height: 6),
              MedicationDropdownField(
                value: _duration,
                items: PrescriptionModel.durationOptions,
                onChanged: (val) => setState(() => _duration = val!),
              ),

              const SizedBox(height: 14),

              // ── Instructions ──
              const MedicationFieldLabel(label: 'Instructions'),
              const SizedBox(height: 6),
              MedicationInputField(
                controller: _instructionsController,
                hint: 'e.g., Take in the morning with food',
                maxLines: 3,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter instructions' : null,
              ),

              const SizedBox(height: 14),

              // ── Start Date ──
              const MedicationFieldLabel(label: 'Start Date'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(_startDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .inverseSurface,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Save Button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        PrescriptionModel(
                          id: widget.prescription.id,
                          medicationName: _nameController.text.trim(),
                          dosage: _dosageController.text.trim(),
                          frequency: _frequency,
                          duration: _duration,
                          instructions:
                              _instructionsController.text.trim(),
                          startDate: _formatDate(_startDate),
                          status: widget.prescription.status,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}