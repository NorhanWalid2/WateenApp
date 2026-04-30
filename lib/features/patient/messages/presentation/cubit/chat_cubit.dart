import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/services/signalr_service.dart';
import 'package:wateen_app/features/patient/messages/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';

import '../../data/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  static final ChatCubit _instance = ChatCubit._internal();
  factory ChatCubit() => _instance;

  ChatCubit._internal() : super(ChatInitial()) {
    // ✅ Use addOn* — won't overwrite doctor cubit callbacks
    SignalRService().addOnMessageReceived(_onMessageReceived);
    SignalRService().addOnMessagesRead(_onMessagesRead);
  }

  List<ConversationModel> _lastConversations = [];
  final ChatRepository _repo = ChatRepository();
  final Map<String, List<ChatMessageModel>> _cache = {};
  String? _currentOtherUserId;

  void _emit(ChatState state) {
    if (!isClosed) emit(state);
  }

  // ── SignalR callbacks ─────────────────────────────────────────────

  void _onMessageReceived(Map<String, dynamic> data) {
    print('Patient ChatCubit incoming message: $data');

    final senderId = (data['senderId'] ?? '').toString();
    final currentUserId = AppPrefs.userId ?? '';

    if (senderId == currentUserId) return;

    final otherUserId = senderId;
    final msg = ChatMessageModel.fromJson(data, currentUserId: currentUserId);

    _cache.putIfAbsent(otherUserId, () => []);

    // Avoid duplicates
    final exists = _cache[otherUserId]!.any((m) => m.id == msg.id);
    if (!exists) _cache[otherUserId]!.add(msg);

    if (otherUserId == _currentOtherUserId) {
      _markAsRead(otherUserId);
      _emit(MessageReceived(List.from(_cache[otherUserId]!)));
    } else {
      _refreshConversationsSilently();
    }
  }

  void _onMessagesRead(String byUserId) {
    print('Patient MessagesRead by: $byUserId');

    final myId = AppPrefs.userId ?? '';

    // Skip if it's me who read (not the doctor)
    if (byUserId == myId) return;

    // Only update if it's the currently open conversation
    if (_currentOtherUserId != null && byUserId == _currentOtherUserId) {
      _markMyMessagesAsRead(byUserId);
    }

    _refreshConversationsSilently();
  }

  void _markMyMessagesAsRead(String otherUserId) {
    if (!_cache.containsKey(otherUserId)) return;

    _cache[otherUserId] = _cache[otherUserId]!.map((m) {
      if (m.sender == ChatMessageSender.me) {
        return m.copyWith(status: ChatMessageStatus.read);
      }
      return m;
    }).toList();

    if (_currentOtherUserId == otherUserId) {
      _emit(MessagesLoaded(List.from(_cache[otherUserId]!)));
    }
  }

  // ── Load conversations ────────────────────────────────────────────

  Future<void> loadConversations() async {
    _emit(ConversationsLoading());
    try {
      await SignalRService().connect();
      final conversations = await _repo.loadConversations();
      final enriched = _enrich(conversations);
      _lastConversations = enriched;
      _emit(ConversationsLoaded(enriched));
    } catch (e) {
      print('loadConversations error: $e');
      _emit(ConversationsError('Failed to load conversations'));
    }
  }

  // ── Load history ──────────────────────────────────────────────────

  Future<void> loadHistory(String otherUserId) async {
    await SignalRService().connect();
    _currentOtherUserId = otherUserId;

    // Show cache immediately
    if (_cache.containsKey(otherUserId) && _cache[otherUserId]!.isNotEmpty) {
      _emit(MessagesLoaded(List.from(_cache[otherUserId]!)));
    } else {
      _emit(MessagesLoading());
    }

    try {
      final messages = await _repo.loadHistory(otherUserId);
      final oldMessages = _cache[otherUserId] ?? [];

      // ✅ FIX: For MY outgoing messages, only mark as read if:
      // - Cache already has them as read (from SignalR MessagesRead event)
      // - Never trust API isRead field — REST markAsRead is called by doctor
      //   which sets isRead=true on API, but patient should only see blue ticks
      //   when MessagesRead SignalR event fires
      final merged = messages.map((newMsg) {
        if (newMsg.sender == ChatMessageSender.me) {
          // Check if cache has this message already marked as read via SignalR
          final cached = oldMessages.where((m) => m.id == newMsg.id);
          if (cached.isNotEmpty && cached.first.status == ChatMessageStatus.read) {
            return newMsg.copyWith(status: ChatMessageStatus.read);
          }
          // Otherwise keep as delivered — ignore API isRead field
          return newMsg.copyWith(status: ChatMessageStatus.delivered);
        }
        // For incoming messages — trust the API
        return newMsg;
      }).toList();

      _cache[otherUserId] = merged;
      _emit(MessagesLoaded(List.from(merged)));

      if (merged.isNotEmpty) await _markAsRead(otherUserId);
    } catch (e) {
      print('loadHistory error: $e');
      if (_cache.containsKey(otherUserId)) {
        _emit(MessagesLoaded(List.from(_cache[otherUserId]!)));
      } else {
        _emit(MessagesLoaded([]));
      }
    }
  }

  // ── Send message ──────────────────────────────────────────────────

  Future<void> sendMessage(String receiverId, String content) async {
    if (content.trim().isEmpty) return;
    try {
      await SignalRService().connect();

      final msg = ChatMessageModel.local(
        text: content,
        receiverId: receiverId,
        currentUserId: AppPrefs.userId ?? '',
      );

      _cache.putIfAbsent(receiverId, () => []);
      _cache[receiverId]!.add(msg);
      _emit(MessageSent(List.from(_cache[receiverId]!)));

      await SignalRService().sendMessage(receiverId, content);
      _refreshConversationsSilently();
    } catch (e) {
      print('Send error: $e');
      _emit(ChatError('Failed to send message'));
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Future<void> _refreshConversationsSilently() async {
    try {
      final conversations = await _repo.loadConversations();
      final enriched = _enrich(conversations);
      _lastConversations = enriched;
      _emit(ConversationsLoaded(enriched));
    } catch (e) {
      print('Silent refresh error: $e');
    }
  }

  List<ConversationModel> _enrich(List<ConversationModel> conversations) {
    return conversations.map((c) {
      if (c.lastMessage.isEmpty &&
          _cache.containsKey(c.otherUserId) &&
          _cache[c.otherUserId]!.isNotEmpty) {
        final lastMsg = _cache[c.otherUserId]!.last;
        return ConversationModel(
          otherUserId: c.otherUserId,
          doctorName: c.doctorName,
          specialty: c.specialty,
          lastMessage: lastMsg.text ?? '',
          time: _formatTime(lastMsg.time),
          lastDateTime: lastMsg.time,
          unreadCount: c.unreadCount,
          initials: c.initials,
          color: c.color,
          isOnline: c.isOnline,
          profilePictureUrl: c.profilePictureUrl,
        );
      }
      return c;
    }).toList();
  }

  Future<void> _markAsRead(String otherUserId) async {
    try {
      await _repo.markAsRead(otherUserId);
      await SignalRService().markAsRead(otherUserId);
      print('Patient marked as read: $otherUserId');
    } catch (e) {
      print('markAsRead error: $e');
    }
  }

  void leaveConversation() {
    _currentOtherUserId = null;
  }

  void clearCache() {
    _cache.clear();
    _lastConversations = [];
    _currentOtherUserId = null;
    _emit(ChatInitial());
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}';
  }

  @override
  Future<void> close() async {
    // Singleton — don't close, but remove listeners to avoid duplicates
    // if app somehow recreates the singleton
    SignalRService().removeOnMessageReceived(_onMessageReceived);
    SignalRService().removeOnMessagesRead(_onMessagesRead);
  }
}