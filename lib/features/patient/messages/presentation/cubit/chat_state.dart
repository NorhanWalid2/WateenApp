import 'package:wateen_app/features/patient/messages/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';

 

abstract class ChatState {}
class ChatInitial extends ChatState {}
class ChatConnecting extends ChatState {}
class ChatConnected extends ChatState {}
class ChatConnectionError extends ChatState { 
  final String message;
  ChatConnectionError(this.message);
}
class ConversationsLoading extends ChatState {}
class ConversationsLoaded extends ChatState {
  final List<ConversationModel> conversations;
  ConversationsLoaded(this.conversations);
}
class ConversationsError extends ChatState {
  final String message;
  ConversationsError(this.message);
}
class MessagesLoading extends ChatState {}
class MessagesLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  MessagesLoaded(this.messages);
}
class MessageSent extends ChatState {
  final List<ChatMessageModel> messages;
  MessageSent(this.messages);
}
class MessageReceived extends ChatState {
  final List<ChatMessageModel> messages;
  MessageReceived(this.messages);
}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}