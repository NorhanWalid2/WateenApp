import '../../data/models/patient_task_model.dart';
 
abstract class PatientTaskState {}
class PatientTaskInitial extends PatientTaskState {}
class PatientTaskLoading extends PatientTaskState {}
class PatientTaskLoaded extends PatientTaskState {
  final List<PatientTaskModel> tasks;
  final bool isCompleted;
  PatientTaskLoaded(this.tasks, {required this.isCompleted});
}
class PatientTaskActionSuccess extends PatientTaskState {
  final String message;
  PatientTaskActionSuccess(this.message);
}
class PatientTaskError extends PatientTaskState {
  final String message;
  PatientTaskError(this.message);
}
 