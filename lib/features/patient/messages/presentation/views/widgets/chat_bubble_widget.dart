import 'dart:io';
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

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    switch (message.status) {
      case ChatMessageStatus.sent:
        return Icon(Icons.check_rounded, size: 14,
            color: Colors.white.withOpacity(0.7));
      case ChatMessageStatus.delivered:
        return Icon(Icons.done_all_rounded, size: 14,
            color: Colors.white.withOpacity(0.7));
      case ChatMessageStatus.read:
        return const Icon(Icons.done_all_rounded, size: 14,
            color: Colors.lightBlueAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMe = message.sender == ChatMessageSender.me; // ← fixed

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Other Avatar ─────────────────
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
                  style: textTheme.bodySmall?.copyWith(
                    color: conversation.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],

          // ── Bubble ────────────────────────
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: message.type == ChatMessageType.image
                  ? const EdgeInsets.all(4)
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? colorScheme.secondary : colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.type == ChatMessageType.image
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(message.imagePath!),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.text ?? '',
                          style: textTheme.bodyMedium?.copyWith(
                            color: isMe
                                ? Colors.white
                                : colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: isMe
                                    ? Colors.white.withOpacity(0.7)
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              _buildStatusIcon(colorScheme),
                            ],
                          ],
                        ),
                      ],
                    ),
            ),
          ),

          if (isMe) const SizedBox(width: 6),
        ],
      ),
    );
  }
}