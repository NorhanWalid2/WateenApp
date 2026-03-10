import 'package:flutter/material.dart';

class ConversationModel {
  final String doctorName;
  final String specialty;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String initials;
  final Color color;
  final bool isOnline;

  ConversationModel({
    required this.doctorName,
    required this.specialty,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.initials,
    required this.color,
    required this.isOnline,
  });
}