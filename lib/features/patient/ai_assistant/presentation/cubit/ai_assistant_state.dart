import 'package:wateen_app/features/patient/ai_assistant/data/models/diagnosis_model.dart';

 
abstract class DiagnosisState {}

class DiagnosisInitial extends DiagnosisState {}

class DiagnosisLoading extends DiagnosisState {}

class DiagnosisLoaded extends DiagnosisState {
  final DiagnosisModel diagnosis;
  final String symptoms;
  DiagnosisLoaded(this.diagnosis, this.symptoms);
}

class DiagnosisError extends DiagnosisState {
  final String message;
  DiagnosisError(this.message);
}