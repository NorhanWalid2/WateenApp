// lib/features/doctor_role/dashboard/presentation/cubit/doctor_dashboard_state.dart

import 'package:wateen_app/features/doctor_role/dashboard/data/models/doctor_dashboard_model.dart';

abstract class DoctorDashboardState {}

class DoctorDashboardInitial extends DoctorDashboardState {}
class DoctorDashboardLoading extends DoctorDashboardState {}

class DoctorDashboardLoaded extends DoctorDashboardState {
  final DoctorDashboardModel data;
  DoctorDashboardLoaded(this.data);
}

class DoctorDashboardError extends DoctorDashboardState {
  final String message;
  DoctorDashboardError(this.message);
}