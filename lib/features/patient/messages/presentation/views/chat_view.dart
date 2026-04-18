import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  const ChatView({super.key, required this.conversation});

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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
    // For now just show locally — image upload API needed for persistence
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

  // ── Extract messages from any state that carries them ──────────────
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

    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is MessageReceived || state is MessageSent) {
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.conversation.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.conversation.initials,
                          style: textTheme.titleSmall?.copyWith(
                            color: widget.conversation.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
                icon: Icon(Icons.videocam_outlined,
                    color: colorScheme.inverseSurface),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert_rounded,
                    color: colorScheme.inverseSurface),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // ── Messages list ──────────────────────────────────────
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.secondary,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            itemCount: messages.length,
                            itemBuilder: (_, i) => ChatBubbleWidget(
                              message: messages[i],
                              conversation: widget.conversation,
                            ),
                          ),
              ),

              // ── Input ─────────────────────────────────────────────
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