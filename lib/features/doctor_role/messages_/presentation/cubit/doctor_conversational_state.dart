// ── States ────────────────────────────────────────────────────────────────────

import 'package:wateen_app/features/doctor_role/messages_/data/models/doctor_conversational_model.dart';

abstract class DoctorConversationsState {}

class DoctorConversationsInitial extends DoctorConversationsState {}

class DoctorConversationsLoading extends DoctorConversationsState {}

class DoctorConversationsLoaded extends DoctorConversationsState {
  final List<DoctorConversationModel> conversations;
  DoctorConversationsLoaded(this.conversations);

  List<DoctorConversationModel> get unread =>
      conversations.where((c) => c.unreadCount > 0).toList();
  List<DoctorConversationModel> get urgent =>
      conversations.where((c) => c.isUrgent).toList();
}

class DoctorConversationsError extends DoctorConversationsState {
  final String message;
  DoctorConversationsError(this.message);
}