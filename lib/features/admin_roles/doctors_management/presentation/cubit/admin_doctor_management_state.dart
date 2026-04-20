import 'package:wateen_app/features/admin_roles/doctors_management/data/models/pending_doctor_model.dart';

abstract class DoctorAdminState {}

class DoctorAdminInitial extends DoctorAdminState {}

class DoctorAdminLoading extends DoctorAdminState {}

class DoctorAdminLoaded extends DoctorAdminState {
  final List<PendingDoctorModel> doctors;
  DoctorAdminLoaded(this.doctors);
}

class DoctorAdminError extends DoctorAdminState {
  final String message;
  DoctorAdminError(this.message);
}

class DoctorAdminActionLoading extends DoctorAdminState {
  final List<PendingDoctorModel> doctors;
  final String userId;
  DoctorAdminActionLoading(this.doctors, this.userId);
}

class DoctorAdminActionSuccess extends DoctorAdminState {
  final List<PendingDoctorModel> doctors;
  final String message;
  DoctorAdminActionSuccess(this.doctors, this.message);
}

class DoctorAdminActionError extends DoctorAdminState {
  final List<PendingDoctorModel> doctors;
  final String message;
  DoctorAdminActionError(this.doctors, this.message);
}