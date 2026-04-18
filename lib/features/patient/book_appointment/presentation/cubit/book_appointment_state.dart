
// ── States ─────────────────────────────────────────────────────────────────────
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';

abstract class BookAppointmentState {}
class BookAppointmentInitial   extends BookAppointmentState {}
class BookAppointmentLoading   extends BookAppointmentState {}
class BookAppointmentLoaded    extends BookAppointmentState {
  final List<BookAppointmentModel> doctors;
  BookAppointmentLoaded(this.doctors);
}
class BookAppointmentError     extends BookAppointmentState {
  final String message;
  BookAppointmentError(this.message);
}
