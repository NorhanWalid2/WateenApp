// lib/features/doctor_role/messages_/presentation/views/widgets/conversation_card_widget.dart

import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/messages_/data/models/doctor_conversational_model.dart';

class ConversationCardWidget extends StatelessWidget {
  final DoctorConversationModel conversation;
  final VoidCallback onTap;

  const ConversationCardWidget({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  bool _isValidUrl(String? url) {
    if (url == null) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          border: Border(
            bottom: BorderSide(color: colorScheme.surface, width: 1),
          ),
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFE8EEF9),
                  backgroundImage: _isValidUrl(conversation.profilePictureUrl)
                      ? NetworkImage(conversation.profilePictureUrl!)
                      : null,
                  child: !_isValidUrl(conversation.profilePictureUrl)
                      ? Text(
                          conversation.patientName.isNotEmpty
                              ? conversation.patientName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3B82F6),
                          ),
                        )
                      : null,
                ),
                if (conversation.isUrgent)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.priority_high_rounded,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // ── Text ────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.patientName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: colorScheme.inverseSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: conversation.unreadCount > 0
                          ? colorScheme.inverseSurface
                          : colorScheme.outlineVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: colorScheme.outlineVariant),
                      const SizedBox(width: 4),
                      Text(
                        conversation.timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Status indicator ─────────────────────────────────────
            // ✅ Only show unread badge OR nothing — remove the always-blue tick
            // Blue tick should only appear inside the chat bubble, not here
            if (conversation.unreadCount > 0)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    conversation.unreadCount > 9
                        ? '9+'
                        : conversation.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}