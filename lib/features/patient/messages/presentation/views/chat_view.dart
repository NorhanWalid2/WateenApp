import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wateen_app/core/widgets/shimmer_widget.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_cubit.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_state.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/messages/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/widgets/chat_bubble_widget.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/widgets/chat_input_widget.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/widgets/attach_item_widget.dart';

class ChatView extends StatefulWidget {
  final ConversationModel conversation;

  const ChatView({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatView> createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadHistory(widget.conversation.otherUserId);
  }

  @override
  void dispose() {
    ChatCubit().leaveConversation();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  ImageProvider? _buildImage(String? path) {
    if (path == null || path.trim().isEmpty) return null;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    return NetworkImage('http://wateen.runasp.net/$path');
  }

  void scrollToBottom({bool instant = false}) {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) return;

      if (scrollController.hasClients) {
        if (instant) {
          scrollController.jumpTo(0);
        } else {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    controller.clear();

    context.read<ChatCubit>().sendMessage(
          widget.conversation.otherUserId,
          text,
        );

    scrollToBottom();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null || !mounted) return;
    setState(() {});
  }

  void showAttachOptions() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(l10n.attach, style: textTheme.titleMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AttachItemWidget(
                    icon: Icons.camera_alt_rounded,
                    label: l10n.camera,
                    color: colorScheme.secondary,
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                  ),
                  AttachItemWidget(
                    icon: Icons.photo_library_rounded,
                    label: l10n.gallery,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                  ),
                  AttachItemWidget(
                    icon: Icons.insert_drive_file_rounded,
                    label: l10n.document,
                    color: Colors.blue,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<ChatMessageModel> _messagesFromState(ChatState state) {
    if (state is MessagesLoaded) return state.messages;
    if (state is MessageSent) return state.messages;
    if (state is MessageReceived) return state.messages;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final avatarImage = _buildImage(widget.conversation.profilePictureUrl);

    return BlocConsumer<ChatCubit, ChatState>(
      buildWhen: (prev, curr) =>
          curr is MessagesLoading ||
          curr is MessagesLoaded ||
          curr is MessageSent ||
          curr is MessageReceived ||
          curr is ChatError,
      listenWhen: (prev, curr) =>
          curr is MessagesLoaded ||
          curr is MessageSent ||
          curr is MessageReceived,
      listener: (context, state) {
        if (state is MessagesLoaded) {
          scrollToBottom(instant: true);
        } else if (state is MessageReceived || state is MessageSent) {
          scrollToBottom();
        }
      },
      builder: (context, state) {
        final messages = _messagesFromState(state);
        final isLoading = state is MessagesLoading;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.primary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: colorScheme.inverseSurface,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          widget.conversation.color.withOpacity(0.15),
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                          ? Text(
                              widget.conversation.initials,
                              style: textTheme.titleSmall?.copyWith(
                                color: widget.conversation.color,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    if (widget.conversation.isOnline)
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.conversation.doctorName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.conversation.isOnline
                          ? l10n.online
                          : widget.conversation.specialty,
                      style: textTheme.bodySmall?.copyWith(
                        color: widget.conversation.isOnline
                            ? Colors.green
                            : colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.videocam_outlined,
                  color: colorScheme.inverseSurface,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.inverseSurface,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: isLoading
                    ? ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: 6,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: i % 2 == 0
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (i % 2 != 0) ...[
                                const ShimmerWidget(
                                  width: 28,
                                  height: 28,
                                  borderRadius: 14,
                                ),
                                const SizedBox(width: 6),
                              ],
                              ShimmerWidget(
                                width: i % 2 == 0 ? 180 : 140,
                                height: 44,
                                borderRadius: 16,
                              ),
                            ],
                          ),
                        ),
                      )
                    : messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No messages yet.\nSay hello!',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            reverse: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: messages.length,
                            itemBuilder: (_, i) {
                              final reversedMessages =
                                  messages.reversed.toList();

                              return ChatBubbleWidget(
                                message: reversedMessages[i],
                                conversation: widget.conversation,
                              );
                            },
                          ),
              ),
              ChatInputWidget(
                controller: controller,
                onSend: sendMessage,
                onAttach: showAttachOptions,
              ),
            ],
          ),
        );
      },
    );
  }
}