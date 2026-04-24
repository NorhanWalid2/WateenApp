enum ChatMessageType { text, image }
enum ChatMessageSender { me, other }
enum ChatMessageStatus { sent, delivered, read }

class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String chatId;
  final String? text;
  final String? imagePath;
  final DateTime time;
  final ChatMessageType type;
  final ChatMessageSender sender;
  final ChatMessageStatus status;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.chatId,
    this.text,
    this.imagePath,
    required this.time,
    required this.type,
    required this.sender,
    required this.status,
  });

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final senderId = (json['senderId'] ?? '').toString();
    final isMe = senderId == currentUserId;

    return ChatMessageModel(
      id: (json['id'] ?? '').toString(),
      senderId: senderId,
      senderName: (json['senderName'] ?? '').toString(),
      receiverId: (json['receiverId'] ?? '').toString(),
      chatId: (json['chatId'] ?? '').toString(),
      text: json['messageContent']?.toString() ?? '',
time: DateTime.tryParse(json['sentAt']?.toString() ?? '')?.toLocal() ??
    DateTime.now(),
      type: ChatMessageType.text,
      sender: isMe ? ChatMessageSender.me : ChatMessageSender.other,
      status: (json['isRead'] == true)
          ? ChatMessageStatus.read
          : ChatMessageStatus.delivered,
    );
  }

  // For locally created messages (before API confirms)
  factory ChatMessageModel.local({
    required String text,
    required String receiverId,
    required String currentUserId,
  }) {
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      senderName: '',
      receiverId: receiverId,
      chatId: '',
      text: text,
      time: DateTime.now(),
      type: ChatMessageType.text,
      sender: ChatMessageSender.me,
      status: ChatMessageStatus.sent,
    );
  }
}