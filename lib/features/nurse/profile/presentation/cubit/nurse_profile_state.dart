import '../../data/models/nurse_profile_model.dart';

abstract class NurseProfileState {}

class NurseProfileInitial extends NurseProfileState {}

class NurseProfileLoading extends NurseProfileState {}

class NurseProfileLoaded extends NurseProfileState {
  final NurseProfileModel profile;

  NurseProfileLoaded(this.profile);
}

class NurseProfileUpdating extends NurseProfileState {
  final NurseProfileModel profile;

  NurseProfileUpdating(this.profile);
}

class NurseProfileUpdated extends NurseProfileState {
  final NurseProfileModel profile;
  final String message;

  NurseProfileUpdated(this.profile, this.message);
}

class NurseProfileError extends NurseProfileState {
  final String message;

  NurseProfileError(this.message);
}