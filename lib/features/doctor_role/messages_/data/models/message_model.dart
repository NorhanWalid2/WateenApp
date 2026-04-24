enum MessageFilter { all, unread, urgent }

class ConversationModel {
  final String id;
  final String patientName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isUrgent;
  final bool isRead;

  ConversationModel({
    required this.id,
    required this.patientName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isUrgent,
    required this.isRead,
  });
}