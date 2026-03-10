import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I\'m your AI health assistant. How can I help you today?',
      sender: MessageSender.ai,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      type: MessageType.text,
    ),
  ];

  final List<String> _suggestions = [
    'I have a headache',
    'Check my blood pressure',
    'Calculate meal calories',
    'Medication reminder',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          sender: MessageSender.user,
          time: DateTime.now(),
          type: MessageType.text,
        ),
      );
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text:
                'I understand your concern. As an AI health assistant, I can provide general health information. However, for specific medical concerns, please consult with your doctor through our appointment system.',
            sender: MessageSender.ai,
            time: DateTime.now(),
            type: MessageType.text,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    setState(() {
      _messages.add(
        ChatMessage(
          imagePath: image.path,
          sender: MessageSender.user,
          time: DateTime.now(),
          type: MessageType.image,
        ),
      );
      _isTyping = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text:
                'I can see the image you\'ve shared. For accurate medical analysis, please consult a healthcare professional.',
            sender: MessageSender.ai,
            time: DateTime.now(),
            type: MessageType.text,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void showAttachmentOptions() {
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
                  Text('Attach', style: textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AttachOptionWidget(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        color: colorScheme.secondary,
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.camera);
                        },
                      ),
                      AttachOptionWidget(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.gallery);
                        },
                      ),
                      AttachOptionWidget(
                        icon: Icons.insert_drive_file_rounded,
                        label: 'Document',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: file picker
                        },
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
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: colorScheme.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Health Assistant',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
                      'Online',
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
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicatorWidget();
                }
                return MessageBubbleWidget(message: _messages[index]);
              },
            ),
          ),
          if (_messages.length == 1)
            SuggestionsBarWidget(suggestions: _suggestions, onTap: sendMessage),
          ChatInputBarWidget(
            controller: _controller,
            onSend: sendMessage,
            onAttach: showAttachmentOptions,
          ),
        ],
      ),
    );
  }
}
