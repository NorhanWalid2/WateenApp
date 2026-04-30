// lib/features/doctor_role/chat_/data/models/doctor_chat_model.dart

enum MessageSender { doctor, patient }

class DoctorChatMessageModel {
  final String id;
  final String text;
  final MessageSender sender;
  final String time;
  final bool isRead;

  const DoctorChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
    this.isRead = false,
  });

  // ── From REST history endpoint ────────────────────────────────────
  // { id, senderId, receiverId, messageContent, sentAt, isRead }
  factory DoctorChatMessageModel.fromJson(
      Map<String, dynamic> json, String myUserId) {
    final senderId = (json['senderId'] ?? '').toString();
    final isDoctor = senderId == myUserId;

    return DoctorChatMessageModel(
      id: (json['id'] ?? '').toString(),
      text: (json['messageContent'] ?? json['content'] ?? json['message'] ?? '').toString(),
      sender: isDoctor ? MessageSender.doctor : MessageSender.patient,
      time: _parseTime(json['sentAt'] ?? json['createdAt'] ?? ''),
      isRead: _parseBool(json['isRead']),
    );
  }

  // ── From SignalR ReceiveMessage event ─────────────────────────────
  // same shape as REST: { senderId, receiverId, messageContent, sentAt, isRead }
  factory DoctorChatMessageModel.fromSignalR(
      Map<String, dynamic> data, String myUserId) {
    final senderId = (data['senderId'] ?? '').toString();
    final isDoctor = senderId == myUserId;

    bool parseIsRead(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      return v.toString().toLowerCase() == 'true';
    }

    return DoctorChatMessageModel(
      id: (data['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      text: (data['messageContent'] ?? data['content'] ?? '').toString(),
      sender: isDoctor ? MessageSender.doctor : MessageSender.patient,
      time: _parseTime(data['sentAt'] ?? ''),
      isRead: parseIsRead(data['isRead']),
    );
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    return v.toString().toLowerCase() == 'true';
  }

  static String _parseTime(dynamic raw) {
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      final hour =
          dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return raw.toString();
    }
  }
}