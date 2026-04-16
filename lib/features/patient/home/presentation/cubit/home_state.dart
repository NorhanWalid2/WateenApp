import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final PatientProfileModel profile;
  HomeLoaded(this.profile);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}