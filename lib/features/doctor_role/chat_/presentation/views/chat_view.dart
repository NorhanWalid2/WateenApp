import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/chat_model.dart';
import 'widgets/chat_bubble_widget.dart';
import 'widgets/chat_input_widget.dart';

class DoctorChatView extends StatefulWidget {
  final String patientName;
  final String patientId;

  const DoctorChatView({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  @override
  State<DoctorChatView> createState() => _DoctorChatViewState();
}

class _DoctorChatViewState extends State<DoctorChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // TODO: replace with real API data
  final List<DoctorChatMessageModel> _messages = [
    DoctorChatMessageModel(
      id: '1',
      text:
          'Good morning Doctor! I wanted to follow up on my blood pressure readings.',
      sender: MessageSender.patient,
      time: '9:30 AM',
    ),
    DoctorChatMessageModel(
      id: '2',
      text:
          "Good morning! I'd be happy to help. What readings have you been getting?",
      sender: MessageSender.doctor,
      time: '9:32 AM',
    ),
    DoctorChatMessageModel(
      id: '3',
      text: 'This morning it was 145/95. Should I be concerned?',
      sender: MessageSender.patient,
      time: '9:35 AM',
    ),
    DoctorChatMessageModel(
      id: '4',
      text:
          "That's slightly elevated. Have you been taking your medication as prescribed?",
      sender: MessageSender.doctor,
      time: '9:37 AM',
    ),
    DoctorChatMessageModel(
      id: '5',
      text:
          "Yes, I've been taking it every morning with breakfast as you suggested.",
      sender: MessageSender.patient,
      time: '9:40 AM',
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        DoctorChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _messageController.text.trim(),
          sender: MessageSender.doctor,
          time: _formatTime(DateTime.now()),
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color:
                            Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EEF9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.patientName[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Text(
                    widget.patientName,
                    style: GoogleFonts.archivo(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color:
                          Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ── Messages ──
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubbleWidget(message: _messages[index]);
                },
              ),
            ),

            // ── Input ──
            ChatInputWidget(
              controller: _messageController,
              onSend: _sendMessage,
              onAttachment: () {
                // TODO: implement attachment
              },
            ),
          ],
        ),
      ),
    );
  }
}