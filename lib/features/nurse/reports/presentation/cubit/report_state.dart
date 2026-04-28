import 'package:wateen_app/features/nurse/reports/data/models/report_model.dart';

 
abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<ReportModel> patients;
  final int totalCount;
  ReportsLoaded(this.patients, this.totalCount);
}

class ReportsError extends ReportsState {
  final String message;
  ReportsError(this.message);
}