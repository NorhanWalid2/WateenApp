enum MessageSender { doctor, patient }

class DoctorChatMessageModel {
  final String id;
  final String text;
  final MessageSender sender;
  final String time;

  DoctorChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });
}