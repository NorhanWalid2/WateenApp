import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/chat_message_model.dart';

class MessageBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: colorScheme.secondary,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding:
                  message.type == MessageType.image
                      ? const EdgeInsets.all(4)
                      : const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
              decoration: BoxDecoration(
                color: isUser ? colorScheme.secondary : colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  message.type == MessageType.image
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(message.imagePath!),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            message.text!,
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  isUser ? Colors.white : colorScheme.onSurface,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color:
                                  isUser
                                      ? Colors.white.withOpacity(0.7)
                                      : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
