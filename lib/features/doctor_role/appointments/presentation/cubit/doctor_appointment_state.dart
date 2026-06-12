// lib/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart

import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';

abstract class DoctorAppointmentsState {}

class DoctorAppointmentsInitial extends DoctorAppointmentsState {}

class DoctorAppointmentsLoading extends DoctorAppointmentsState {}

class DoctorAppointmentsLoaded extends DoctorAppointmentsState {
  final List<DoctorAppointmentModel> appointments;
  DoctorAppointmentsLoaded(this.appointments);
}

class DoctorAppointmentsError extends DoctorAppointmentsState {
  final String message;
  DoctorAppointmentsError(this.message);
}

class DoctorAppointmentActionLoading extends DoctorAppointmentsState {
  final String appointmentId;
  DoctorAppointmentActionLoading(this.appointmentId);
}

class DoctorAppointmentActionSuccess extends DoctorAppointmentsState {
  final String message;
  DoctorAppointmentActionSuccess(this.message);
}

class DoctorAppointmentActionError extends DoctorAppointmentsState {
  final String message;
  DoctorAppointmentActionError(this.message);
}