// lib/features/doctor_role/prescriptions/presentation/cubit/prescriptions_state.dart

import 'package:wateen_app/features/doctor_role/prescriptions/data/prescription_model.dart';

abstract class PrescriptionsState {}

class PrescriptionsInitial extends PrescriptionsState {}

class PrescriptionsLoading extends PrescriptionsState {}

class PrescriptionsLoaded extends PrescriptionsState {
  final List<PrescriptionModel> prescriptions;
  PrescriptionsLoaded(this.prescriptions);

  List<PrescriptionModel> get active =>
      prescriptions.where((p) => p.status == PrescriptionStatus.active).toList();

  List<PrescriptionModel> get past =>
      prescriptions.where((p) => p.status == PrescriptionStatus.past).toList();
}

class PrescriptionsError extends PrescriptionsState {
  final String message;
  PrescriptionsError(this.message);
}

class PrescriptionActionSuccess extends PrescriptionsState {
  final String message;
  PrescriptionActionSuccess(this.message);
}