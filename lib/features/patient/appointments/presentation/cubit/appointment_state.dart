import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> past;

  AppointmentLoaded({
    required this.upcoming,
    required this.past,
  });
}

class AppointmentError extends AppointmentState {
  final String message;
  AppointmentError(this.message);
}