import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_cubit.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_state.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/chat_view.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/widgets/conversation_tile_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class ConversationsView extends StatefulWidget {
  const ConversationsView({super.key});

  @override
  State<ConversationsView> createState() => ConversationsViewState();
}

class ConversationsViewState extends State<ConversationsView> {
  final TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final conversations =
            state is ConversationsLoaded
                ? state.conversations
                : <ConversationModel>[];

        final filtered =
            conversations
                .where(
                  (c) =>
                      c.doctorName.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

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
                    l10n.messages,
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
                        hintText: l10n.searchDoctors,
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

            // ── Body ─────────────────────────────
            Expanded(
              child: _buildBody(
                context,
                state,
                filtered,
                colorScheme,
                textTheme,
                l10n,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ChatState state,
    List<ConversationModel> filtered,
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic l10n,
  ) {
    if (state is ConversationsLoading) {
      return ListView.separated(
        itemCount: 6,
        separatorBuilder:
            (_, __) => Divider(
              height: 1,
              indent: 76,
              color: colorScheme.outline.withOpacity(0.2),
            ),
        itemBuilder: (_, __) => const ShimmerConversationTileWidget(),
      );
    }
    if (state is ConversationsError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => context.read<ChatCubit>().loadConversations(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          l10n.noConversationsFound,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    // Sort: most recent first
    final sorted = [...filtered]..sort((a, b) {
      if (a.lastDateTime == null && b.lastDateTime == null) return 0;
      if (a.lastDateTime == null) return 1;
      if (b.lastDateTime == null) return -1;
      return b.lastDateTime!.compareTo(a.lastDateTime!); // newest first
    });

    return ListView.separated(
      itemCount: sorted.length,
      separatorBuilder:
          (_, __) => Divider(
            height: 1,
            indent: 76,
            color: colorScheme.outline.withOpacity(0.2),
          ),
      itemBuilder:
          (_, i) => ConversationTileWidget(
            conversation: sorted[i],
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: context.read<ChatCubit>(),
                          child: ChatView(conversation: sorted[i]),
                        ),
                  ),
                ).then((_) {
                  if (context.mounted) {
                    context.read<ChatCubit>().loadConversations();
                  }
                }),
          ),
    );
  }
}
