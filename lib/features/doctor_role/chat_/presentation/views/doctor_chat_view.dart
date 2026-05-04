import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/chat_/data/models/doctor_chat_model.dart';
import 'package:wateen_app/features/doctor_role/chat_/presentation/cubit/doctoe_char_cubit.dart';
import 'package:wateen_app/features/doctor_role/chat_/presentation/cubit/doctor_chat_state.dart';
import 'widgets/chat_bubble_widget.dart';
import 'widgets/chat_input_widget.dart';

class DoctorChatView extends StatelessWidget {
  final String patientName;
  final String patientId;
  final String? patientProfilePicture;

  const DoctorChatView({
    super.key,
    required this.patientName,
    required this.patientId,
    this.patientProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorChatCubit(otherUserId: patientId)
        ..fetchHistory()
        ..startPolling(),
      child: _DoctorChatBody(
        patientName: patientName,
        patientProfilePicture: patientProfilePicture,
      ),
    );
  }
}

class _DoctorChatBody extends StatefulWidget {
  final String patientName;
  final String? patientProfilePicture;

  const _DoctorChatBody({
    required this.patientName,
    this.patientProfilePicture,
  });

  @override
  State<_DoctorChatBody> createState() => _DoctorChatBodyState();
}

class _DoctorChatBodyState extends State<_DoctorChatBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    context.read<DoctorChatCubit>().leaveConversation();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ImageProvider? _buildImage(String? path) {
    if (path == null || path.trim().isEmpty) return null;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    return NetworkImage('https://wateen.runasp.net/$path');
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    context.read<DoctorChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = _buildImage(widget.patientProfilePicture);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE8EEF9),
                    backgroundImage: avatarImage,
                    child: avatarImage == null
                        ? Text(
                            widget.patientName.isNotEmpty
                                ? widget.patientName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3B82F6),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.patientName,
                          style: GoogleFonts.archivo(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        BlocBuilder<DoctorChatCubit, DoctorChatState>(
                          builder: (context, state) {
                            return Text(
                              state is DoctorChatSending
                                  ? 'Sending...'
                                  : 'Patient',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
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
              child: BlocConsumer<DoctorChatCubit, DoctorChatState>(
                buildWhen: (_, __) => true,
                listener: (context, state) {
                  if (state is DoctorChatLoaded ||
                      state is DoctorChatSending) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is DoctorChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorChatError) {
                    return Center(
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
                            state.message,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                context.read<DoctorChatCubit>().fetchHistory(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final messages = state is DoctorChatLoaded
                      ? state.messages
                      : state is DoctorChatSending
                          ? state.messages
                          : <DoctorChatMessageModel>[];

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color:
                                Theme.of(context).colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No messages yet.\nSay hello!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubbleWidget(message: messages[index]);
                    },
                  );
                },
              ),
            ),
            ChatInputWidget(
              controller: _messageController,
              onSend: _sendMessage,
              onAttachment: () {},
            ),
          ],
        ),
      ),
    );
  }
}