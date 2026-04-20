import 'package:wateen_app/features/admin_roles/homeService_management/data/models/pending_nurse_model.dart';

abstract class NurseAdminState {}

class NurseAdminInitial extends NurseAdminState {}

class NurseAdminLoading extends NurseAdminState {}

class NurseAdminLoaded extends NurseAdminState {
  final List<PendingNurseModel> nurses;
  NurseAdminLoaded(this.nurses);
}

class NurseAdminError extends NurseAdminState {
  final String message;
  NurseAdminError(this.message);
}

class NurseAdminActionLoading extends NurseAdminState {
  final List<PendingNurseModel> nurses;
  final String userId;
  NurseAdminActionLoading(this.nurses, this.userId);
}

class NurseAdminActionSuccess extends NurseAdminState {
  final List<PendingNurseModel> nurses;
  final String message;
  NurseAdminActionSuccess(this.nurses, this.message);
}

class NurseAdminActionError extends NurseAdminState {
  final List<PendingNurseModel> nurses;
  final String message;
  NurseAdminActionError(this.nurses, this.message);
}