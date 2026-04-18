import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';

abstract class NurseState {}

class NurseInitial extends NurseState {}

class NurseLoading extends NurseState {}

class NurseLoaded extends NurseState {
  final List<NurseModel> nurses;
  NurseLoaded(this.nurses);
}

class NurseError extends NurseState {
  final String message;
  NurseError(this.message);
}

// ── Booking states ─────────────────────────────────────────────────────────────
class NurseBookingLoading extends NurseState {}

class NurseBookingSuccess extends NurseState {}

class NurseBookingError extends NurseState {
  final String message;
  NurseBookingError(this.message);
}