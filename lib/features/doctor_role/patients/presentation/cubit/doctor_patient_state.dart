// ── States ────────────────────────────────────────────────────────────────────

import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';

abstract class DoctorPatientsState {}
class DoctorPatientsInitial extends DoctorPatientsState {}
class DoctorPatientsLoading extends DoctorPatientsState {}
class DoctorPatientsLoaded extends DoctorPatientsState {
  final List<PatientModel> patients;
  DoctorPatientsLoaded(this.patients);
}
class DoctorPatientsError extends DoctorPatientsState {
  final String message;
  DoctorPatientsError(this.message);
}

// Patient detail states
abstract class PatientDetailState {}
class PatientDetailInitial extends PatientDetailState {}
class PatientDetailLoading extends PatientDetailState {}
class PatientDetailLoaded extends PatientDetailState {
  final PatientModel patient;
  PatientDetailLoaded(this.patient);
}
class PatientDetailError extends PatientDetailState {
  final String message;
  PatientDetailError(this.message);
}
