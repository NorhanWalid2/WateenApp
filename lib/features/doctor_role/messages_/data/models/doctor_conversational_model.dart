class DoctorConversationModel {
  final String id;
  final String patientName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isUrgent;
  final bool isRead;
  final String? profilePictureUrl;

  const DoctorConversationModel({
    required this.id,
    required this.patientName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isUrgent,
    required this.isRead,
    this.profilePictureUrl,
  });

  factory DoctorConversationModel.fromJson(Map<String, dynamic> json) {
    final lastMsg =
        json['lastMessage'] is Map ? json['lastMessage'] as Map : null;

    final rawTime = lastMsg?['sentAt'] ?? json['lastMessageTime'] ?? '';

    String timeAgo = '';
    try {
      final dt = DateTime.parse(rawTime.toString()).toLocal();
      final diff = DateTime.now().difference(dt);

      if (diff.inMinutes < 1) {
        timeAgo = 'Just now';
      } else if (diff.inMinutes < 60) {
        timeAgo = '${diff.inMinutes} min ago';
      } else if (diff.inHours < 24) {
        timeAgo = '${diff.inHours} hours ago';
      } else if (diff.inDays == 1) {
        timeAgo = 'Yesterday';
      } else {
        timeAgo = '${diff.inDays} days ago';
      }
    } catch (_) {
      timeAgo = rawTime.toString();
    }

    final unread = int.tryParse((json['unreadCount'] ?? 0).toString()) ?? 0;

    return DoctorConversationModel(
      id: (json['otherUserId'] ?? '').toString(),
      patientName: (json['otherUserName'] ?? 'Unknown').toString(),
      lastMessage: lastMsg != null
          ? (lastMsg['messageContent'] ?? '').toString()
          : '',
      timeAgo: timeAgo,
      unreadCount: unread,
      isUrgent: unread > 0,
      isRead: unread == 0,
      profilePictureUrl: json['otherUserProfilePicture']?.toString(),
    );
  }
}