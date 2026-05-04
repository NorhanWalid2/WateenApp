// lib/features/patient/ai_assistant/presentation/cubit/ai_assistant_state.dart

import 'package:wateen_app/features/patient/ai_assistant/data/models/chat_message_model.dart';

abstract class AiAssistantState {}

class AiAssistantInitial extends AiAssistantState {}

class AiAssistantLoaded extends AiAssistantState {
  final List<ChatMessage> messages;
  final bool isTyping;
  // Timestamp forces rebuild even with same messages count
  final DateTime timestamp;

  AiAssistantLoaded(this.messages, {required this.isTyping})
      : timestamp = DateTime.now();
}

class AiAssistantError extends AiAssistantState {
  final String message;
  AiAssistantError(this.message);
}