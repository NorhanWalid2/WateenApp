import 'package:wateen_app/features/nurse/home/data/models/nurse_request_model.dart';

 
abstract class NurseHomeState {}

class NurseHomeInitial extends NurseHomeState {}

class NurseHomeLoading extends NurseHomeState {}

class NurseHomeLoaded extends NurseHomeState {
  final List<NurseHomeRequestModel> requests;
  NurseHomeLoaded(this.requests);
}

class NurseHomeError extends NurseHomeState {
  final String message;
  NurseHomeError(this.message);
}

class NurseHomeActionLoading extends NurseHomeState {
  final List<NurseHomeRequestModel> requests;
  final String requestId;
  NurseHomeActionLoading(this.requests, this.requestId);
}

class NurseHomeActionSuccess extends NurseHomeState {
  final List<NurseHomeRequestModel> requests;
  final String message;
  NurseHomeActionSuccess(this.requests, this.message);
}

class NurseHomeActionError extends NurseHomeState {
  final List<NurseHomeRequestModel> requests;
  final String message;
  NurseHomeActionError(this.requests, this.message);
}