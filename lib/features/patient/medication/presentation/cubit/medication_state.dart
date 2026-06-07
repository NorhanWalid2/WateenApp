// lib/features/patient/medications/presentation/cubit/patient_medication_state.dart

import '../../data/models/patient_medication_model.dart';

abstract class PatientMedicationState {}
class PatientMedicationInitial extends PatientMedicationState {}
class PatientMedicationLoading extends PatientMedicationState {}
class PatientMedicationLoaded extends PatientMedicationState {
  final List<PatientMedicationModel> medications;
  final bool activeOnly;
  PatientMedicationLoaded(this.medications, {required this.activeOnly});
}
class PatientMedicationError extends PatientMedicationState {
  final String message;
  PatientMedicationError(this.message);
}