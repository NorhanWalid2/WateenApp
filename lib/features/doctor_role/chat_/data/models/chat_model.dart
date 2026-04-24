enum MessageSender { doctor, patient }

class ChatMessageModel {
  final String id;
  final String text;
  final MessageSender sender;
  final String time;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });
}