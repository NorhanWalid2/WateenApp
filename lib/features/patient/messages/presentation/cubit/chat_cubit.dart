import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/services/signalr_service.dart';
import 'package:wateen_app/features/patient/messages/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
 
import '../../data/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  // ── Singleton ────────────────────────────────────────────────────
  static final ChatCubit _instance = ChatCubit._internal();
  factory ChatCubit() => _instance;

  // ── Constructor — register callbacks here ────────────────────────
  ChatCubit._internal() : super(ChatInitial()) {
    _registerSignalRCallbacks(); // ← called once when singleton is created
  }
List<ConversationModel> _lastConversations = [];
  final ChatRepository _repo = ChatRepository();
  final Map<String, List<ChatMessageModel>> _cache = {};
  String? _currentOtherUserId;

  // ── Safe emit ────────────────────────────────────────────────────
  void _emit(ChatState state) {
    if (!isClosed) emit(state);
  }

void _registerSignalRCallbacks() {
  SignalRService().onMessageReceived = (data) {
    print('Incoming message: $data');
    final senderId = (data['senderId'] ?? '').toString();
    final currentUserId = AppPrefs.userId ?? '';

    // ← Skip messages sent by me — already added optimistically
    if (senderId == currentUserId) return;

    final receiverId = (data['receiverId'] ?? '').toString();
    final otherUserId = senderId;

    final msg = ChatMessageModel.fromJson(
      data,
      currentUserId: currentUserId,
    );

    _cache.putIfAbsent(otherUserId, () => []);
    _cache[otherUserId]!.add(msg);

    if (otherUserId == _currentOtherUserId) {
      _emit(MessageReceived(List.from(_cache[otherUserId]!)));
    } else {
      _refreshConversationsSilently();
    }
  };
}
  Future<void> loadConversations() async {
  _emit(ConversationsLoading());
  try {
    final conversations = await _repo.loadConversations();
    final enriched = conversations.map((c) {
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
    _lastConversations = enriched;
    _emit(ConversationsLoaded(enriched));
  } catch (e) {
    print('loadConversations error: $e');
    _emit(ConversationsLoaded([]));
  }
}

  // ── Step 2: Load chat history ─────────────────────────────────────
  Future<void> loadHistory(String otherUserId) async {
    _currentOtherUserId = otherUserId;

    // Show cache immediately if available
    if (_cache.containsKey(otherUserId) &&
        _cache[otherUserId]!.isNotEmpty) {
      _emit(MessagesLoaded(List.from(_cache[otherUserId]!)));
      _markAsRead(otherUserId);
      return;
    }

    _emit(MessagesLoading());
    try {
      final messages = await _repo.loadHistory(otherUserId);
      _cache[otherUserId] = messages;
      _emit(MessagesLoaded(List.from(messages)));
      _markAsRead(otherUserId);
    } catch (e) {
      _cache[otherUserId] = [];
      _emit(MessagesLoaded([]));
    }
  }

 // ── Step 3: Send message ──────────────────────────────────────────
Future<void> sendMessage(String receiverId, String content) async {
  if (content.trim().isEmpty) return;
  try {
    // Add optimistically to cache
    final msg = ChatMessageModel.local(
      text: content,
      receiverId: receiverId,
      currentUserId: AppPrefs.userId ?? '',
    );
    _cache.putIfAbsent(receiverId, () => []);
    _cache[receiverId]!.add(msg);
    _emit(MessageSent(List.from(_cache[receiverId]!)));

    // Send via SignalR
    await SignalRService().sendMessage(receiverId, content);

    // Refresh inbox silently (no loading state)
    _refreshConversationsSilently();
  } catch (e) {
    print('Send error: $e');
    _emit(ChatError('Failed to send message'));
  }
}
// ── Load conversations without emitting loading state ─────────────
Future<void> _refreshConversationsSilently() async {
  try {
    final conversations = await _repo.loadConversations();
    final enriched = conversations.map((c) {
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
    // Only emit if we're on conversations screen
    if (_currentOtherUserId == null) {
      _emit(ConversationsLoaded(enriched));
    }
    // Store for later use
    _lastConversations = enriched;
  } catch (e) {
    print('Silent refresh error: $e');
  }
}

  // ── Mark as read ──────────────────────────────────────────────────
  Future<void> _markAsRead(String otherUserId) async {
    try {
      await _repo.markAsRead(otherUserId);
      await SignalRService().markAsRead(otherUserId);
    } catch (_) {}
  }

  // ── Leave conversation ────────────────────────────────────────────
  void leaveConversation() {
    _currentOtherUserId = null;
  }

  // ── Clear on logout ───────────────────────────────────────────────
  void clearCache() {
    _cache.clear();
    _currentOtherUserId = null;
  }

  // ── Helper ────────────────────────────────────────────────────────
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
    // Don't close singleton — keep alive for whole session
  }
}