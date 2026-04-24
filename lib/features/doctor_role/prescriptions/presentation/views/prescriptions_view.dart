import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/data/prescription_model.dart';
import 'widgets/prescription_card_widget.dart';
import 'widgets/add_medication_dialog_widget.dart';
import 'widgets/edit_medication_dialog_widget.dart';

class PrescriptionsView extends StatefulWidget {
  final PatientModel patient;

  const PrescriptionsView({super.key, required this.patient});

  @override
  State<PrescriptionsView> createState() => _PrescriptionsViewState();
}

class _PrescriptionsViewState extends State<PrescriptionsView> {
  bool _isActiveTab = true;

  // TODO: replace with real API data
  final List<PrescriptionModel> _prescriptions = [
    PrescriptionModel(
      id: '1',
      medicationName: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      duration: 'Ongoing',
      instructions: 'Take in the morning with food',
      startDate: '12/1/2025',
      status: PrescriptionStatus.active,
    ),
    PrescriptionModel(
      id: '2',
      medicationName: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      duration: 'Ongoing',
      instructions: 'Take with breakfast and dinner',
      startDate: '12/1/2025',
      status: PrescriptionStatus.active,
    ),
    PrescriptionModel(
      id: '3',
      medicationName: 'Atorvastatin',
      dosage: '20mg',
      frequency: 'Once daily',
      duration: 'Ongoing',
      instructions: 'Take at bedtime',
      startDate: '1/15/2026',
      status: PrescriptionStatus.active,
    ),
    PrescriptionModel(
      id: '4',
      medicationName: 'Amoxicillin',
      dosage: '500mg',
      frequency: 'Three times daily',
      duration: '7 days',
      instructions: 'Complete full course',
      startDate: '11/10/2025',
      endDate: '11/17/2025',
      status: PrescriptionStatus.past,
    ),
  ];

  List<PrescriptionModel> get _activePrescriptions =>
      _prescriptions.where((p) => p.status == PrescriptionStatus.active).toList();

  List<PrescriptionModel> get _pastPrescriptions =>
      _prescriptions.where((p) => p.status == PrescriptionStatus.past).toList();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddMedicationDialogWidget(
        onAdd: (prescription) {
          setState(() => _prescriptions.add(prescription));
        },
      ),
    );
  }

  void _showEditDialog(PrescriptionModel prescription) {
    showDialog(
      context: context,
      builder: (_) => EditMedicationDialogWidget(
        prescription: prescription,
        onSave: (updated) {
          setState(() {
            final index =
                _prescriptions.indexWhere((p) => p.id == updated.id);
            if (index != -1) _prescriptions[index] = updated;
          });
        },
      ),
    );
  }

  void _downloadPrescriptions() {
    // TODO: implement download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Downloading prescriptions...'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList =
        _isActiveTab ? _activePrescriptions : _pastPrescriptions;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Prescriptions',
                    style: GoogleFonts.archivo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    // ── Patient card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.patient.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Current Medications',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.medication_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Tabs ──
                    Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            label:
                                'Active (${_activePrescriptions.length})',
                            isActive: _isActiveTab,
                            onTap: () =>
                                setState(() => _isActiveTab = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TabButton(
                            label: 'Past (${_pastPrescriptions.length})',
                            isActive: !_isActiveTab,
                            onTap: () =>
                                setState(() => _isActiveTab = false),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Action buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showAddDialog,
                            icon: const Icon(Icons.add_rounded,
                                color: Colors.white, size: 18),
                            label: const Text(
                              'Add New',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _downloadPrescriptions,
                            icon: Icon(
                              Icons.download_rounded,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface,
                            ),
                            label: Text(
                              'Download',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Prescriptions list ──
                    displayList.isEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No ${_isActiveTab ? 'active' : 'past'} prescriptions',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final prescription = displayList[index];
                              return PrescriptionCardWidget(
                                prescription: prescription,
                                onEdit: () =>
                                    _showEditDialog(prescription),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}