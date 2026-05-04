import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/cubit/ai_assistant_state.dart';
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
    controller.clear();
    context.read<AiAssistantCubit>().sendMessage(text);
    scrollToBottom();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null || !mounted) return;

    // Add image message locally
    // Image analysis via AI is a future enhancement
    setState(() {});
    scrollToBottom();
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
                width: 40, height: 4,
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
    return BlocProvider(
      create: (_) => AiAssistantCubit(),
      child: _AiAssistantBody(
        controller: controller,
        scrollController: scrollController,
        onSend: sendMessage,
        onAttach: showAttachmentOptions,
      ),
    );
  }
}

class _AiAssistantBody extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final void Function(String) onSend;
  final VoidCallback onAttach;

  const _AiAssistantBody({
    required this.controller,
    required this.scrollController,
    required this.onSend,
    required this.onAttach,
  });

  void _scrollToBottom() {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AiAssistantCubit, AiAssistantState>(
      listener: (context, state) {
        if (state is AiAssistantLoaded) _scrollToBottom();
      },
      builder: (context, state) {
        final messages = state is AiAssistantLoaded
            ? state.messages
            : context.read<AiAssistantCubit>().messages;
        final isTyping =
            state is AiAssistantLoaded ? state.isTyping : false;

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
                    width: 38, height: 38,
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
                            width: 7, height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isTyping ? 'Typing...' : l10n.online,
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
                // Clear conversation button
                IconButton(
                  icon: Icon(Icons.refresh_rounded,
                      color: colorScheme.onSurface),
                  tooltip: 'Clear conversation',
                  onPressed: () => context
                      .read<AiAssistantCubit>()
                      .clearConversation(),
                ),
              ],
            ),
            body: Column(
              children: [
                // ── Messages ──────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && isTyping) {
                        return const TypingIndicatorWidget();
                      }
                      return MessageBubbleWidget(message: messages[index]);
                    },
                  ),
                ),

                // ── Suggestions (only on first message) ───────────
                if (messages.length == 1)
                  SuggestionsBarWidget(
                    suggestions: [
                      l10n.suggestionHeadache,
                      l10n.suggestionBloodPressure,
                      l10n.suggestionMealCalories,
                      l10n.suggestionMedication,
                    ],
                    onTap: onSend,
                  ),

                // ── Input ─────────────────────────────────────────
                ChatInputBarWidget(
                  controller: controller,
                  onSend: onSend,
                  onAttach: onAttach,
                ),
              ],
            ),
          );
        },
      );
  }
}