import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/widgets/attach_option_widget.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/widgets/chat_input_bar_widget.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/widgets/message_bubble_widget.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/widgets/suggestions_bar_widget.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/widgets/typing_indicator_widget.dart';

class AiAssistantView extends StatefulWidget {
  const AiAssistantView({super.key});

  @override
  State<AiAssistantView> createState() => AiAssistantViewState();
}

class AiAssistantViewState extends State<AiAssistantView> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  bool isTyping = false;

  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'Hello! I\'m your AI health assistant. How can I help you today?',
      sender: MessageSender.ai,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      type: MessageType.text,
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
      messages.add(ChatMessage(
        text: text,
        sender: MessageSender.user,
        time: DateTime.now(),
        type: MessageType.text,
      ));
      isTyping = true;
    });

    controller.clear();
    scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        isTyping = false;
        messages.add(ChatMessage(
          text:
              'I understand your concern. As an AI health assistant, I can provide general health information. However, for specific medical concerns, please consult with your doctor through our appointment system.',
          sender: MessageSender.ai,
          time: DateTime.now(),
          type: MessageType.text,
        ));
      });
      scrollToBottom();
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    setState(() {
      messages.add(ChatMessage(
        imagePath: image.path,
        sender: MessageSender.user,
        time: DateTime.now(),
        type: MessageType.image,
      ));
      isTyping = true;
    });

    scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        isTyping = false;
        messages.add(ChatMessage(
          text:
              'I can see the image you\'ve shared. For accurate medical analysis, please consult a healthcare professional.',
          sender: MessageSender.ai,
          time: DateTime.now(),
          type: MessageType.text,
        ));
      });
      scrollToBottom();
    });
  }

  void showAttachmentOptions() {
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
                  AttachOptionWidget(
                    icon: Icons.camera_alt_rounded,
                    label: l10n.camera,
                    color: colorScheme.secondary,
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                  ),
                  AttachOptionWidget(
                    icon: Icons.photo_library_rounded,
                    label: l10n.gallery,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                  ),
                  AttachOptionWidget(
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
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_rounded,
                  color: colorScheme.secondary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiHealthAssistant,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.online,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
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
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return const TypingIndicatorWidget();
                }
                return MessageBubbleWidget(message: messages[index]);
              },
            ),
          ),
          if (messages.length == 1)
            SuggestionsBarWidget(
              suggestions: [
                l10n.suggestionHeadache,
                l10n.suggestionBloodPressure,
                l10n.suggestionMealCalories,
                l10n.suggestionMedication,
              ],
              onTap: sendMessage,
            ),
          ChatInputBarWidget(
            controller: controller,
            onSend: sendMessage,
            onAttach: showAttachmentOptions,
          ),
        ],
      ),
    );
  }
}