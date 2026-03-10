enum ChatMessageType { text, image }
enum ChatMessageSender { patient, doctor }
enum ChatMessageStatus { sent, delivered, read }

class ChatMessageModel {
  final String? text;
  final String? imagePath;
  final ChatMessageSender sender;
  final DateTime time;
  final ChatMessageType type;
  final ChatMessageStatus status;

  ChatMessageModel({
    this.text,
    this.imagePath,
    required this.sender,
    required this.time,
    required this.type,
    this.status = ChatMessageStatus.sent,
  });
}