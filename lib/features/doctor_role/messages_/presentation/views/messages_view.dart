import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/messages_/data/models/message_model.dart';
import 'widgets/conversation_card_widget.dart';

class DoctorMessagesView extends StatefulWidget {
  const DoctorMessagesView({super.key});

  @override
  State<DoctorMessagesView> createState() => _DoctorMessagesViewState();
}

class _DoctorMessagesViewState extends State<DoctorMessagesView> {
  MessageFilter _selectedFilter = MessageFilter.all;

  // TODO: replace with real API data
  final List<ConversationModel> _conversations = [
    ConversationModel(
      id: '1',
      patientName: 'Ahmed Al-Mansouri',
      lastMessage:
          'Doctor, my blood pressure reading was 145/95 this morning. Should I be concerned?',
      timeAgo: '10 min ago',
      unreadCount: 2,
      isUrgent: true,
      isRead: false,
    ),
    ConversationModel(
      id: '2',
      patientName: 'Fatima Hassan',
      lastMessage:
          'Thank you for the prescription. When should I schedule my next appointment?',
      timeAgo: '2 hours ago',
      unreadCount: 1,
      isUrgent: false,
      isRead: false,
    ),
    ConversationModel(
      id: '3',
      patientName: 'Mohammed Ali',
      lastMessage:
          "I've been taking the medication as prescribed. Feeling much better now!",
      timeAgo: 'Yesterday',
      unreadCount: 0,
      isUrgent: false,
      isRead: true,
    ),
    ConversationModel(
      id: '4',
      patientName: 'Layla Ahmed',
      lastMessage: 'Can I reschedule my appointment to next week?',
      timeAgo: '2 days ago',
      unreadCount: 0,
      isUrgent: false,
      isRead: true,
    ),
  ];

  List<ConversationModel> get _filteredConversations {
    switch (_selectedFilter) {
      case MessageFilter.unread:
        return _conversations.where((c) => c.unreadCount > 0).toList();
      case MessageFilter.urgent:
        return _conversations.where((c) => c.isUrgent).toList();
      case MessageFilter.all:
      default:
        return _conversations;
    }
  }

  int get _unreadCount =>
      _conversations.where((c) => c.unreadCount > 0).length;

  int get _urgentCount =>
      _conversations.where((c) => c.isUrgent).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Messages',
                    style: GoogleFonts.archivo(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Filter chips ──
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All Messages',
                          isActive:
                              _selectedFilter == MessageFilter.all,
                          onTap: () => setState(
                              () => _selectedFilter = MessageFilter.all),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Unread $_unreadCount',
                          isActive:
                              _selectedFilter == MessageFilter.unread,
                          onTap: () => setState(
                              () => _selectedFilter = MessageFilter.unread),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Urgent $_urgentCount',
                          isActive:
                              _selectedFilter == MessageFilter.urgent,
                          onTap: () => setState(
                              () => _selectedFilter = MessageFilter.urgent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Conversations list ──
            Expanded(
              child: _filteredConversations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No messages',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredConversations.length,
                      itemBuilder: (context, index) {
                        final conversation =
                            _filteredConversations[index];
                        return ConversationCardWidget(
                          conversation: conversation,
                          onTap: () {
                            context.push(
                              '/doctorChat',
                              extra: <String, dynamic>{
                                'patientName': conversation.patientName,
                                'patientId': conversation.id,
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}