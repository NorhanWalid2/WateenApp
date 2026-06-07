// lib/features/patient/medical_records/presentation/cubit/medical_records_state.dart

import 'package:wateen_app/features/patient/medical_record/data/models/medical_record_model.dart';
 
abstract class MedicalRecordsState {}

class MedicalRecordsInitial extends MedicalRecordsState {}
class MedicalRecordsLoading extends MedicalRecordsState {}

class MedicalRecordsLoaded extends MedicalRecordsState {
  final List<MedicalRecordModel> records;
  MedicalRecordsLoaded(this.records);
}

class MedicalRecordsError extends MedicalRecordsState {
  final String message;
  MedicalRecordsError(this.message);
}

class MedicalRecordActionSuccess extends MedicalRecordsState {
  final String message;
  MedicalRecordActionSuccess(this.message);
}

class MedicalRecordActionError extends MedicalRecordsState {
  final String message;
  MedicalRecordActionError(this.message);
}