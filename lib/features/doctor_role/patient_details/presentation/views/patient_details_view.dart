import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import '../../data/models/patient_details_model.dart';
import 'widgets/patient_header_card_widget.dart';
import 'widgets/blood_pressure_chart_widget.dart';
import 'widgets/medical_history_widget.dart';
import 'widgets/medication_adherence_widget.dart';
import 'widgets/action_buttons_widget.dart';

class PatientDetailsView extends StatelessWidget {
  final PatientModel patient;

  const PatientDetailsView({super.key, required this.patient});

  // TODO: replace with real API data
  PatientDetailsModel _getDetails() {
    return PatientDetailsModel(
      id: patient.id,
      name: patient.name,
      age: patient.age,
      gender: 'Male',
      patientId: 'WAT-${patient.id.padLeft(5, '0')}',
      bloodPressureReadings: [120, 125, 118, 130, 128],
      medicalHistory: [
        'Hypertension (5 years)',
        'Type 2 Diabetes (3 years)',
        'No known allergies',
      ],
      medicationAdherencePercent: 85,
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = _getDetails();

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
                    'Patient Details',
                    style: GoogleFonts.archivo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    // Patient header card
                    PatientHeaderCardWidget(patient: details),
                    const SizedBox(height: 16),

                    // Blood pressure chart
                    BloodPressureChartWidget(
                      readings: details.bloodPressureReadings,
                    ),
                    const SizedBox(height: 16),

                    // Medical history
                    MedicalHistoryWidget(history: details.medicalHistory),
                    const SizedBox(height: 16),

                    // Medication adherence
                    MedicationAdherenceWidget(
                      percent: details.medicationAdherencePercent,
                    ),
                    const SizedBox(height: 20),

                    // Action buttons
                    PatientActionButtonsWidget(
                      onMessage: () => context.push(
                        '/doctorChat',
                        extra: {
                          'patientName': patient.name,
                          'patientId': patient.id,
                        },
                      ),
                      onPrescription: () => context.push(
                        '/prescriptions',
                        extra: patient,
                      ),
                      onChecklist: () => context.push(
                        '/checklist',
                        extra: patient,
                      ),
                    ),

                    const SizedBox(height: 20),
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