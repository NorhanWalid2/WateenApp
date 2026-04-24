enum MessageFilter { all, unread, urgent }

class DoctorConversationModel {
  final String id;
  final String patientName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isUrgent;
  final bool isRead;

  DoctorConversationModel({
    required this.id,
    required this.patientName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isUrgent,
    required this.isRead,
  });
}