import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/messages_/data/models/doctor_conversational_model.dart';
import 'package:wateen_app/features/doctor_role/messages_/presentation/cubit/doctor_conversational_state.dart';
import 'package:wateen_app/features/doctor_role/messages_/presentation/cubit/doctor_conversatonal_cubit.dart';
import 'widgets/conversation_card_widget.dart';

class DoctorMessagesView extends StatefulWidget {
  const DoctorMessagesView({super.key});

  @override
  State<DoctorMessagesView> createState() => _DoctorMessagesViewState();
}

class _DoctorMessagesViewState extends State<DoctorMessagesView> {
  late final DoctorConversationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DoctorConversationsCubit()..fetchConversations();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const _DoctorMessagesBody(),
    );
  }
}

class _DoctorMessagesBody extends StatefulWidget {
  const _DoctorMessagesBody();

  @override
  State<_DoctorMessagesBody> createState() => _DoctorMessagesBodyState();
}

class _DoctorMessagesBodyState extends State<_DoctorMessagesBody> {
  MessageFilter _selectedFilter = MessageFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: BlocBuilder<DoctorConversationsCubit, DoctorConversationsState>(
          builder: (context, state) {
            final conversations = state is DoctorConversationsLoaded
                ? state.conversations
                : <DoctorConversationModel>[];

            final unreadCount =
                conversations.where((c) => c.unreadCount > 0).length;

            final urgentCount =
                conversations.where((c) => c.isUrgent).length;

            List<DoctorConversationModel> filtered;
            switch (_selectedFilter) {
              case MessageFilter.unread:
                filtered =
                    conversations.where((c) => c.unreadCount > 0).toList();
                break;
              case MessageFilter.urgent:
                filtered = conversations.where((c) => c.isUrgent).toList();
                break;
              default:
                filtered = conversations;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Messages',
                            style: GoogleFonts.archivo(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context
                                .read<DoctorConversationsCubit>()
                                .fetchConversations(),
                            child: Icon(
                              Icons.refresh_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'All Messages',
                              isActive: _selectedFilter == MessageFilter.all,
                              onTap: () {
                                setState(
                                  () => _selectedFilter = MessageFilter.all,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Unread $unreadCount',
                              isActive:
                                  _selectedFilter == MessageFilter.unread,
                              onTap: () {
                                setState(
                                  () => _selectedFilter = MessageFilter.unread,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Urgent $urgentCount',
                              isActive:
                                  _selectedFilter == MessageFilter.urgent,
                              onTap: () {
                                setState(
                                  () => _selectedFilter = MessageFilter.urgent,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state) {
                    DoctorConversationsLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    DoctorConversationsError(:final message) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context
                                  .read<DoctorConversationsCubit>()
                                  .fetchConversations(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    _ => filtered.isEmpty
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
                        : RefreshIndicator(
                            onRefresh: () => context
                                .read<DoctorConversationsCubit>()
                                .fetchConversations(),
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final conversation = filtered[index];

                                return ConversationCardWidget(
                                  conversation: conversation,
                                  onTap: () {
                                    context.push(
                                      '/doctorChat',
                                      extra: <String, dynamic>{
                                        'patientName':
                                            conversation.patientName,
                                        'patientId': conversation.id,
                                        'patientProfilePicture':
                                            conversation.profilePictureUrl,
                                      },
                                    ).then((_) {
                                      if (context.mounted) {
                                        context
                                            .read<DoctorConversationsCubit>()
                                            .fetchConversations();
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum MessageFilter { all, unread, urgent }

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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