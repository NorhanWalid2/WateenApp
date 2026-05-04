// lib/features/patient/book_appointment/presentation/cubit/book_appointment_state.dart

import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';

abstract class BookAppointmentState {}

class BookAppointmentInitial extends BookAppointmentState {}

class BookAppointmentLoading extends BookAppointmentState {}

class BookAppointmentLoaded extends BookAppointmentState {
  final List<BookAppointmentModel> doctors;
  BookAppointmentLoaded(this.doctors);
}

class BookAppointmentError extends BookAppointmentState {
  final String message;
  BookAppointmentError(this.message);
}

// ── Slots states ──────────────────────────────────────────────────────────────

class BookAppointmentSlotsLoading extends BookAppointmentState {}

class BookAppointmentSlotsLoaded extends BookAppointmentState {
  final List<CalendlySlot> slots;
  BookAppointmentSlotsLoaded(this.slots);
}

class BookAppointmentSlotsError extends BookAppointmentState {
  final String message;
  BookAppointmentSlotsError(this.message);
}

// ── Booking states ────────────────────────────────────────────────────────────

class BookAppointmentBooking extends BookAppointmentState {}

class BookAppointmentSuccess extends BookAppointmentState {}