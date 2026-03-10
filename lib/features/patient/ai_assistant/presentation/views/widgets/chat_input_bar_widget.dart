import 'package:flutter/material.dart';

class ChatInputBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final VoidCallback onAttach;

  const ChatInputBarWidget({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // ── Attach Button ─────────────────
            GestureDetector(
              onTap: onAttach,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.attach_file_rounded,
                    color: colorScheme.onSurfaceVariant, size: 20),
              ),
            ),
            const SizedBox(width: 10),

            // ── Text Field ────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  style: textTheme.bodyMedium,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: onSend,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // ── Send Button ───────────────────
            GestureDetector(
              onTap: () => onSend(controller.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}