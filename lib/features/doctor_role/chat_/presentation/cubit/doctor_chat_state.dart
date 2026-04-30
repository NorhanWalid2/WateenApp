// lib/features/doctor_role/chat_/presentation/cubit/doctor_chat_state.dart

import 'package:wateen_app/features/doctor_role/chat_/data/models/doctor_chat_model.dart';

abstract class DoctorChatState {}

class DoctorChatInitial extends DoctorChatState {}

class DoctorChatLoading extends DoctorChatState {}

class DoctorChatLoaded extends DoctorChatState {
  final List<DoctorChatMessageModel> messages;
  // timestamp forces bloc to see this as a NEW state even if message count is same
  final DateTime timestamp;

  DoctorChatLoaded(this.messages) : timestamp = DateTime.now();
}

class DoctorChatError extends DoctorChatState {
  final String message;
  DoctorChatError(this.message);
}

class DoctorChatSending extends DoctorChatState {
  final List<DoctorChatMessageModel> messages;
  DoctorChatSending(this.messages);
}