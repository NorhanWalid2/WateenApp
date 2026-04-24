enum MessageType { text, image }
enum MessageSender { user, ai, doctor }

class ChatMessage {
  final String? text;
  final String? imagePath;
  final MessageSender sender;
  final DateTime time;
  final MessageType type;

  ChatMessage({
    this.text,
    this.imagePath,
    required this.sender,
    required this.time,
    required this.type,
  });
}