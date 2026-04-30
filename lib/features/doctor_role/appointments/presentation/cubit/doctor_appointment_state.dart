// lib/features/doctor_role/appointments/presentation/cubit/doctor_appointments_state.dart

import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';

abstract class DoctorAppointmentsState {}

class DoctorAppointmentsInitial extends DoctorAppointmentsState {}

class DoctorAppointmentsLoading extends DoctorAppointmentsState {}

class DoctorAppointmentsLoaded extends DoctorAppointmentsState {
  final List<DoctorAppointmentModel> appointments;

  DoctorAppointmentsLoaded(this.appointments);

  List<DoctorAppointmentModel> get upcoming => appointments
      .where((a) =>
          a.status == AppointmentStatus.upcoming ||
          a.status == AppointmentStatus.pending)
      .toList();

  List<DoctorAppointmentModel> get completed => appointments
      .where((a) =>
          a.status == AppointmentStatus.completed ||
          a.status == AppointmentStatus.cancelled)
      .toList();
}

class DoctorAppointmentsError extends DoctorAppointmentsState {
  final String message;
  DoctorAppointmentsError(this.message);
}

// Action states — for respond / cancel / complete
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