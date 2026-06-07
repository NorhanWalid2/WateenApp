// lib/features/doctor_role/checklist/presentation/cubit/checklist_state.dart

import 'package:wateen_app/features/doctor_role/checklist/data/models/checklist_model.dart';

abstract class ChecklistState {}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final List<ChecklistTaskModel> tasks;
  ChecklistLoaded(this.tasks);

  List<ChecklistTaskModel> get pending =>
      tasks.where((t) => t.status == TaskStatus.pending).toList();

  List<ChecklistTaskModel> get completed =>
      tasks.where((t) => t.status == TaskStatus.completed).toList();
}

class ChecklistError extends ChecklistState {
  final String message;
  ChecklistError(this.message);
}

class ChecklistActionSuccess extends ChecklistState {
  final String message;
  ChecklistActionSuccess(this.message);
}