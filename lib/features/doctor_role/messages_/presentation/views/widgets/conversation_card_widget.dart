import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';


class ConversationCardWidget extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const ConversationCardWidget({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [

            // ── Avatar ──
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8EEF9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      conversation.patientName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ),
                // Urgent indicator
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
                        border: Border.all(
                            color: Colors.white, width: 2),
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

            // ── Info ──
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
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        conversation.timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Badge / Read indicator ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (conversation.unreadCount > 0)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.done_all_rounded,
                    size: 16,
                    color: Color(0xFF3B82F6),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}