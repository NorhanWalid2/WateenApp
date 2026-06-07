// lib/features/patient/messages/presentation/views/patient_messages_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/widgets/doctor_avatar_widget.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_cubit.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_state.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/chat_view.dart';

class PatientMessagesView extends StatefulWidget {
  const PatientMessagesView({super.key});

  @override
  State<PatientMessagesView> createState() => _PatientMessagesViewState();
}

class _PatientMessagesViewState extends State<PatientMessagesView> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    ChatCubit().loadConversations();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ConversationModel> _filtered(List<ConversationModel> all) {
    final myId = AppPrefs.userId ?? '';
    // ✅ Remove conversations where the "other user" is ourselves
    // This happens when the API returns both sides of a conversation
    final withoutSelf = all.where((c) => c.otherUserId != myId).toList();
    final q = _searchCtrl.text.toLowerCase();
    if (q.isEmpty) return withoutSelf;
    return withoutSelf
        .where((c) => c.doctorName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider.value(
      value: ChatCubit(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Messages', style: textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: colorScheme.outlineVariant, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.inverseSurface),
                              decoration: InputDecoration(
                                hintText: 'Search doctors...',
                                hintStyle: TextStyle(
                                    color: colorScheme.outlineVariant,
                                    fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Conversations list ───────────────────────────────
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  buildWhen: (prev, curr) => curr is ConversationsLoaded ||
                      curr is ConversationsLoading ||
                      curr is ConversationsError,
                  builder: (context, state) {
                    if (state is ConversationsLoading) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (state is ConversationsError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off_rounded,
                                size: 48,
                                color: colorScheme.outlineVariant),
                            const SizedBox(height: 12),
                            Text(state.message,
                                style: TextStyle(
                                    color: colorScheme.outlineVariant)),
                            TextButton(
                              onPressed: () =>
                                  ChatCubit().loadConversations(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final all = state is ConversationsLoaded
                        ? state.conversations
                        : <ConversationModel>[];
                    final conversations = _filtered(all);

                    if (conversations.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded,
                                size: 56,
                                color: colorScheme.outlineVariant),
                            const SizedBox(height: 12),
                            Text('No messages yet',
                                style: TextStyle(
                                    color: colorScheme.outlineVariant,
                                    fontSize: 15)),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => ChatCubit().loadConversations(),
                      child: ListView.builder(
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          final conv = conversations[index];
                          return _ConversationTile(
                            conversation: conv,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: ChatCubit(),
                                  child: ChatView(
                                      conversation: conv),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Conversation Tile ─────────────────────────────────────────────────────────

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          border: Border(
            bottom: BorderSide(
                color: colorScheme.surface, width: 1),
          ),
        ),
        child: Row(
          children: [
            // ✅ Doctor profile picture with initials fallback
            Stack(
              children: [
                DoctorAvatarWidget(
                  imageUrl: conversation.profilePictureUrl,
                  initials: conversation.initials,
                  radius: 26,
                  backgroundColor:
                      conversation.color.withOpacity(0.15),
                  initialsColor: conversation.color,
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: colorScheme.primary, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.doctorName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: colorScheme.inverseSurface,
                        ),
                      ),
                      Text(
                        conversation.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: conversation.unreadCount > 0
                              ? colorScheme.secondary
                              : colorScheme.outlineVariant,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: conversation.unreadCount > 0
                                ? colorScheme.inverseSurface
                                : colorScheme.outlineVariant,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 20, height: 20,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}