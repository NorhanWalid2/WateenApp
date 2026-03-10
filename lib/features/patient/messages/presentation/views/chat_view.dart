import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  final List<ChatMessageModel> messages = [
    ChatMessageModel(
      text: 'Hello! How can I help you today?',
      sender: ChatMessageSender.doctor,
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: ChatMessageType.text,
      status: ChatMessageStatus.read,
    ),
    ChatMessageModel(
      text: 'I have been feeling dizzy lately.',
      sender: ChatMessageSender.patient,
      time: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      type: ChatMessageType.text,
      status: ChatMessageStatus.read,
    ),
    ChatMessageModel(
      text: 'How long have you been experiencing this? Any other symptoms?',
      sender: ChatMessageSender.doctor,
      time: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      type: ChatMessageType.text,
      status: ChatMessageStatus.read,
    ),
    ChatMessageModel(
      text: 'About 3 days. I also have headaches.',
      sender: ChatMessageSender.patient,
      time: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      type: ChatMessageType.text,
      status: ChatMessageStatus.read,
    ),
    ChatMessageModel(
      text: 'Your test results look good! No need to worry.',
      sender: ChatMessageSender.doctor,
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      type: ChatMessageType.text,
      status: ChatMessageStatus.read,
    ),
  ];

  @override
  void dispose() {
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
    setState(() {
      messages.add(
        ChatMessageModel(
          text: text,
          sender: ChatMessageSender.patient,
          time: DateTime.now(),
          type: ChatMessageType.text,
          status: ChatMessageStatus.sent,
        ),
      );
    });
    controller.clear();
    scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        final last = messages.last;
        messages[messages.length - 1] = ChatMessageModel(
          text: last.text,
          sender: last.sender,
          time: last.time,
          type: last.type,
          status: ChatMessageStatus.delivered,
        );
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        final last = messages.last;
        messages[messages.length - 1] = ChatMessageModel(
          text: last.text,
          sender: last.sender,
          time: last.time,
          type: last.type,
          status: ChatMessageStatus.read,
        );
      });
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;
    setState(() {
      messages.add(
        ChatMessageModel(
          imagePath: image.path,
          sender: ChatMessageSender.patient,
          time: DateTime.now(),
          type: ChatMessageType.image,
          status: ChatMessageStatus.sent,
        ),
      );
    });
    scrollToBottom();
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
      builder:
          (_) => SafeArea(
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorScheme.onSurface,
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
                    color:
                        widget.conversation.isOnline
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
            icon: Icon(Icons.videocam_outlined, color: colorScheme.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder:
                  (_, i) => ChatBubbleWidget(
                    message: messages[i],
                    conversation: widget.conversation,
                  ),
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
  }
}
