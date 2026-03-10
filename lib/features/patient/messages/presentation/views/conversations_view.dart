import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/chat_view.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/widgets/conversation_tile_widget.dart';

class ConversationsView extends StatefulWidget {
  const ConversationsView({super.key});

  @override
  State<ConversationsView> createState() => ConversationsViewState();
}

class ConversationsViewState extends State<ConversationsView> {
  final TextEditingController searchController = TextEditingController();
  String query = '';

  final List<ConversationModel> conversations = [
    ConversationModel(
      doctorName: 'Dr. Sarah Johnson',
      specialty: 'General Physician',
      lastMessage: 'Your test results look good! No need to worry.',
      time: '2:30 PM',
      unreadCount: 2,
      initials: 'SJ',
      color: const Color(0xFF4CAF50),
      isOnline: true,
    ),
    ConversationModel(
      doctorName: 'Dr. Ahmed Hassan',
      specialty: 'Cardiologist',
      lastMessage: 'Please take the medication before meals.',
      time: 'Yesterday',
      unreadCount: 0,
      initials: 'AH',
      color: const Color(0xFF2196F3),
      isOnline: false,
    ),
    ConversationModel(
      doctorName: 'Dr. Maria Garcia',
      specialty: 'Dermatologist',
      lastMessage: 'How is the skin condition now?',
      time: 'Mon',
      unreadCount: 1,
      initials: 'MG',
      color: const Color(0xFF9C27B0),
      isOnline: true,
    ),
    ConversationModel(
      doctorName: 'Dr. Fatima Al-Sayed',
      specialty: 'Gynecologist',
      lastMessage: 'See you at your next appointment.',
      time: 'Sun',
      unreadCount: 0,
      initials: 'FA',
      color: const Color(0xFFE91E63),
      isOnline: false,
    ),
  ];

  List<ConversationModel> get filteredConversations =>
      conversations
          .where(
            (c) =>
                c.doctorName.toLowerCase().contains(query.toLowerCase()) ||
                c.specialty.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final filtered = filteredConversations;

    return Column(
      children: [
        // ── Header ───────────────────────────
        Container(
          color: colorScheme.primary,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (v) => setState(() => query = v),
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search doctors...',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── List ─────────────────────────────
        Expanded(
          child:
              filtered.isEmpty
                  ? Center(
                    child: Text(
                      'No conversations found',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                  : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 1,
                          indent: 76,
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                    itemBuilder:
                        (_, i) => ConversationTileWidget(
                          conversation: filtered[i],
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ChatView(conversation: filtered[i]),
                                ),
                              ),
                        ),
                  ),
        ),
      ],
    );
  }
}
