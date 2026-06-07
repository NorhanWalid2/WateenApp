import 'package:flutter/material.dart';

class ConversationModel {
  final String otherUserId;
  final String doctorName;
  final String specialty;
  final String lastMessage;
  final String time;
  final DateTime? lastDateTime;
  final int unreadCount;
  final String initials;
  final Color color;
  final bool isOnline;
  final String? profilePictureUrl;

  ConversationModel({
    required this.otherUserId,
    required this.doctorName,
    required this.specialty,
    required this.lastMessage,
    required this.time,
    this.lastDateTime,
    required this.unreadCount,
    required this.initials,
    required this.color,
    required this.isOnline,
    this.profilePictureUrl,
  });

  bool get isUrgent => unreadCount > 0;
  String get patientName => doctorName;
  String get timeAgo => time.isNotEmpty ? time : '';

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    print('CONV JSON: otherUserName=${json['otherUserName']} pic=${json['otherUserProfilePicture']}');

    // ── Name & initials ──────────────────────────────────────────
    final name = (json['otherUserName'] ?? 'Unknown').toString();
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : '?';

    // ── Color from name hash ─────────────────────────────────────
    const colors = [
      Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFF9C27B0),
      Color(0xFFE91E63), Color(0xFFFF5722), Color(0xFF00BCD4),
      Color(0xFFFF9800),
    ];
    final color = colors[name.hashCode.abs() % colors.length];

    // ── Last message & time ──────────────────────────────────────
    String lastMessage = '';
    String time = '';
    DateTime? lastDateTime;

    final lastMsgRaw = json['lastMessage'];
    if (lastMsgRaw is Map<String, dynamic>) {
      lastMessage = (lastMsgRaw['messageContent'] ?? '').toString();
      final sentAt = lastMsgRaw['sentAt']?.toString();
      if (sentAt != null && sentAt.isNotEmpty) {
        final sentAtUtc = sentAt.endsWith('Z') ? sentAt : '${sentAt}Z';
        lastDateTime = DateTime.tryParse(sentAtUtc)?.toLocal();
        if (lastDateTime != null) {
          time = _formatTime(lastDateTime);
        }
      }
    }

    // ── Profile picture ──────────────────────────────────────────
    // API field name: otherUserProfilePicture
    final pic = json['otherUserProfilePicture']?.toString() ??
        json['profilePictureUrl']?.toString() ??
        json['doctorProfilePicture']?.toString();
    final profilePictureUrl = (pic != null &&
            (pic.startsWith('http://') || pic.startsWith('https://')))
        ? pic
        : null;

    return ConversationModel(
      otherUserId: (json['otherUserId'] ?? '').toString(),
      doctorName: name,
      specialty: (json['specialty'] ?? json['doctorSpecialization'] ?? '').toString(),
      lastMessage: lastMessage,
      time: time,
      lastDateTime: lastDateTime,
      unreadCount: (json['unreadCount'] as int?) ?? 0,
      initials: initials,
      color: color,
      isOnline: json['isOnline'] ?? false,
      profilePictureUrl: profilePictureUrl,
    );
  }

  static String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}';
  }
}