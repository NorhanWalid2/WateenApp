// lib/features/patient/messages/presentation/views/widgets/chat_bubble_widget.dart

import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/messages/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final ConversationModel conversation;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == ChatMessageSender.me;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Doctor avatar (for incoming messages) ──
          if (!isMe) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: conversation.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  conversation.initials,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: conversation.color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // ── Bubble ──
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.68,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? colorScheme.secondary
                      : colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  message.text ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: isMe
                        ? Colors.white
                        : colorScheme.inverseSurface,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ── Time + Read receipt ──
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.outlineVariant,
                    ),
                  ),

                  // ✅ Blue double tick for MY messages
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.status == ChatMessageStatus.read
                          ? Icons.done_all_rounded   // ✓✓ blue = read
                          : Icons.done_rounded,      // ✓ grey = delivered
                      size: 14,
                      color: message.status == ChatMessageStatus.read
                          ? const Color(0xFF3B82F6) // blue
                          : colorScheme.outlineVariant, // grey
                    ),
                  ],
                ],
              ),
            ],
          ),

          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}