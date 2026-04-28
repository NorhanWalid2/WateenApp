import '../../data/models/all_doctors_model.dart';

abstract class AllDoctorsState {}

class AllDoctorsInitial extends AllDoctorsState {}

class AllDoctorsLoading extends AllDoctorsState {}

class AllDoctorsLoaded extends AllDoctorsState {
  final List<AllDoctorsModel> doctors;
  final int totalCount;
  AllDoctorsLoaded(this.doctors, this.totalCount);
}

class AllDoctorsError extends AllDoctorsState {
  final String message;
  AllDoctorsError(this.message);
}

class AllDoctorsDeleteLoading extends AllDoctorsState {
  final List<AllDoctorsModel> doctors;
  final int totalCount;
  final String doctorId;
  AllDoctorsDeleteLoading(this.doctors, this.totalCount, this.doctorId);
}

class AllDoctorsDeleteSuccess extends AllDoctorsState {
  final List<AllDoctorsModel> doctors;
  final int totalCount;
  AllDoctorsDeleteSuccess(this.doctors, this.totalCount);
}

class AllDoctorsDeleteError extends AllDoctorsState {
  final List<AllDoctorsModel> doctors;
  final int totalCount;
  final String message;
  AllDoctorsDeleteError(this.doctors, this.totalCount, this.message);
}