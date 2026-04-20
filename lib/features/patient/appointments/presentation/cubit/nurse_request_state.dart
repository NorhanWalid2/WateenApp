import 'package:wateen_app/features/patient/appointments/data/models/nurse_request_model.dart';

abstract class NurseRequestsState {}

class NurseRequestsInitial extends NurseRequestsState {}

class NurseRequestsLoading extends NurseRequestsState {}

class NurseRequestsLoaded extends NurseRequestsState {
  final List<NurseRequestModel> requests;
  NurseRequestsLoaded(this.requests);
}

class NurseRequestsError extends NurseRequestsState {
  final String message;
  NurseRequestsError(this.message);
}