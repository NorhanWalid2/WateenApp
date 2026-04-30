// lib/features/doctor_role/chat_/presentation/cubit/doctoe_char_cubit.dart

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/services/signalr_service.dart';
import 'package:wateen_app/features/doctor_role/chat_/data/models/doctor_chat_model.dart';
import 'doctor_chat_state.dart';

class DoctorChatCubit extends Cubit<DoctorChatState> {
  final String otherUserId;

  DoctorChatCubit({required this.otherUserId}) : super(DoctorChatInitial()) {
    // Register SignalR — new message arrives while chat is open
    SignalRService().addOnMessageReceived(_onSignalRMessage);
    SignalRService().addOnMessagesRead(_onSignalRMessagesRead);
  }

  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  Timer? _pollingTimer;
  bool _isChatOpen = false;

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  void _safeEmit(DoctorChatState state) {
    if (!isClosed) emit(state);
  }

  // ── SignalR callbacks ─────────────────────────────────────────────

  void _onSignalRMessage(Map<String, dynamic> data) {
    // ✅ If doctor left the chat — do NOT fetch or mark as read
    if (!_isChatOpen) return;

    final senderId = (data['senderId'] ?? '').toString();
    final myId = AppPrefs.userId ?? '';
    if (senderId == myId) return;
    if (senderId != otherUserId) return;

    print('Doctor SignalR: new message from $otherUserId, chatOpen=$_isChatOpen');

    // Show new message in UI
    _fetchHistorySilently();

    // Only mark as read if doctor is STILL actively viewing the chat
    // _isChatOpen is set to false in leaveConversation()
    if (_isChatOpen) {
      _markAsRead();
    }
  }

  void _onSignalRMessagesRead(String byUserId) {
    if (!_isChatOpen || byUserId != otherUserId) return;
    print('Doctor: patient $byUserId read our messages');
    // Refresh to update read ticks
    _fetchHistorySilently();
  }

  // ── Fetch history ─────────────────────────────────────────────────

  Future<void> fetchHistory() async {
    _isChatOpen = true;
    _safeEmit(DoctorChatLoading());

    try {
      await SignalRService().connect();
      await _fetchHistorySilently(showErrors: true);

      // ✅ Mark as read ONCE — only if doctor is still in the chat
      if (_isChatOpen) await _markAsRead();
    } on DioException catch (e) {
      print('DOCTOR CHAT HISTORY ERROR: ${e.response?.data}');
      _safeEmit(DoctorChatError(
        e.response?.data?['message'] ?? 'Failed to load messages',
      ));
    } catch (e, s) {
      print('DOCTOR CHAT HISTORY CATCH: $e\n$s');
      _safeEmit(DoctorChatError('Something went wrong'));
    }
  }

  Future<void> _fetchHistorySilently({bool showErrors = false}) async {
    if (!_isChatOpen) return;
    try {
      final response = await _dio.get(
        "/api/Chat/$otherUserId/history",
        options: _authOptions,
      );

      final List<dynamic> raw = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      final myId = AppPrefs.userId ?? '';
      final messages = raw
          .whereType<Map>()
          .map((e) => DoctorChatMessageModel.fromJson(
                Map<String, dynamic>.from(e), myId))
          .toList();

      if (_isChatOpen && !isClosed) {
        _safeEmit(DoctorChatLoaded(List.from(messages)));
      }
    } catch (e) {
      if (showErrors) rethrow;
      print('Doctor silent history error: $e');
    }
  }

  // ── Send message ──────────────────────────────────────────────────

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || !_isChatOpen) return;

    final tempMsg = DoctorChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      sender: MessageSender.doctor,
      time: _formatTime(DateTime.now()),
      isRead: false,
    );

    // Show optimistic message
    final current = state is DoctorChatLoaded
        ? (state as DoctorChatLoaded).messages
        : state is DoctorChatSending
            ? (state as DoctorChatSending).messages
            : <DoctorChatMessageModel>[];

    _safeEmit(DoctorChatSending([...current, tempMsg]));

    try {
      await SignalRService().sendMessage(otherUserId, text.trim());
      print('Doctor sent: "$text" to $otherUserId');

      // Refresh to get server ID — but DON'T markAsRead here
      await _fetchHistorySilently();
    } catch (e) {
      print('DOCTOR SEND ERROR: $e');
      // Remove optimistic on failure
      final msgs = state is DoctorChatSending
          ? (state as DoctorChatSending).messages
              .where((m) => m.id != tempMsg.id)
              .toList()
          : current;
      _safeEmit(DoctorChatLoaded(msgs));
    }
  }

  // ── Mark as read ──────────────────────────────────────────────────
  // ✅ Only called when doctor explicitly opens chat, NOT on every poll

  Future<void> _markAsRead() async {
    // Double-check — async gap means _isChatOpen could change between call and execution
    if (!_isChatOpen) {
      print('Doctor: skipping markAsRead — already left chat');
      return;
    }
    try {
      await _dio.put(
        "/api/Chat/$otherUserId/read",
        options: _authOptions,
      );
      // Check again after the await — doctor may have left while request was in flight
      if (!_isChatOpen) {
        print('Doctor: left during markAsRead REST — skipping SignalR markAsRead');
        return;
      }
      await SignalRService().markAsRead(otherUserId);
      print('Doctor marked as read: $otherUserId');
    } catch (e) {
      print('Doctor markAsRead error: $e');
    }
  }

  // ── Polling — only fetches history, NEVER marks as read ──────────

  void startPolling() {
    _isChatOpen = true;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        if (!_isChatOpen) return;
        // ✅ Only fetch — do NOT call _markAsRead here
        await _fetchHistorySilently();
      },
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void leaveConversation() {
    // Set flag FIRST synchronously — any pending async operations will check this
    _isChatOpen = false;
    // Cancel polling timer immediately
    stopPolling();
    // Remove SignalR listeners immediately so no more callbacks fire
    SignalRService().removeOnMessageReceived(_onSignalRMessage);
    SignalRService().removeOnMessagesRead(_onSignalRMessagesRead);
    print('Doctor left conversation — all listeners removed');
  }

  @override
  Future<void> close() {
    leaveConversation(); // removes listeners + stops polling
    return super.close();
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}