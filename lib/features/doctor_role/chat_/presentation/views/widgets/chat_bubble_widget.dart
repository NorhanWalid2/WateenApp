import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/chat_/data/models/chat_model.dart';

 
 
class ChatBubbleWidget extends StatelessWidget {
  final DoctorChatMessageModel message;

  const ChatBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDoctor = message.sender == MessageSender.doctor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isDoctor ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isDoctor) const SizedBox(width: 12),

          Column(
            crossAxisAlignment: isDoctor
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.70,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDoctor
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isDoctor ? 16 : 4),
                    bottomRight: Radius.circular(isDoctor ? 4 : 16),
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
                  message.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDoctor
                        ? Colors.white
                        : Theme.of(context).colorScheme.inverseSurface,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.time,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          if (isDoctor) const SizedBox(width: 12),
        ],
      ),
    );
  }
}