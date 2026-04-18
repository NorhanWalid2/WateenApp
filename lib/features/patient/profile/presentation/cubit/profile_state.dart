import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final PatientProfileModel profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {
  final PatientProfileModel profile; // keep showing data while updating
  ProfileUpdating(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final PatientProfileModel profile;
  ProfileUpdateSuccess(this.profile);
}

class ProfileUpdateError extends ProfileState {
  final PatientProfileModel profile; // keep showing data on error
  final String message;
  ProfileUpdateError(this.profile, this.message);
}
