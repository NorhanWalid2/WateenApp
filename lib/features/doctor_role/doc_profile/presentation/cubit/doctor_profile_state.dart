// lib/features/doctor_role/profile/presentation/cubit/doctor_profile_state.dart

import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';
 
abstract class DoctorProfileState {}

class DoctorProfileInitial extends DoctorProfileState {}
class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfileModel profile;
  DoctorProfileLoaded(this.profile);
}

class DoctorProfileUpdating extends DoctorProfileState {
  final DoctorProfileModel profile;
  DoctorProfileUpdating(this.profile);
}

class DoctorProfileUpdateSuccess extends DoctorProfileState {
  final DoctorProfileModel profile;
  DoctorProfileUpdateSuccess(this.profile);
}

class DoctorProfileError extends DoctorProfileState {
  final String message;
  DoctorProfileError(this.message);
}

class DoctorProfileUpdateError extends DoctorProfileState {
  final String message;
  final DoctorProfileModel profile;
  DoctorProfileUpdateError(this.message, this.profile);
}