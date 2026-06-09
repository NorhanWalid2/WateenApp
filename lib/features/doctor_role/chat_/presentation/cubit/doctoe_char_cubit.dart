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
    SignalRService().addOnMessageReceived(_onSignalRMessage);
    SignalRService().addOnMessagesRead(_onSignalRMessagesRead);
  }

  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  final List<DoctorChatMessageModel> _messages = [];
  Timer? _pollingTimer;
  bool _isChatOpen = false;

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  void _safeEmit(DoctorChatState state) {
    if (!isClosed) emit(state);
  }

  Future<void> openChat() async {
    _isChatOpen = true;

    await fetchHistory(showLoading: true);

    startPolling();
  }

  Future<void> fetchHistory({bool showLoading = false}) async {
    if (!_isChatOpen || isClosed) return;

    if (showLoading) {
      _safeEmit(DoctorChatLoading());
    }

    try {
      await SignalRService().connect();

      await _fetchHistorySilently();
    } on DioException catch (e) {
      print('DOCTOR CHAT HISTORY ERROR: ${e.response?.data}');

      _safeEmit(
        DoctorChatError(
          e.response?.data?['message'] ?? 'Failed to load messages',
        ),
      );
    } catch (e, s) {
      print('DOCTOR CHAT HISTORY CATCH: $e');
      print(s);

      _safeEmit(DoctorChatError('Something went wrong'));
    }
  }

  Future<void> _fetchHistorySilently() async {
    if (!_isChatOpen || isClosed) return;

    try {
      final response = await _dio.get(
        "/api/Chat/$otherUserId/history",
        options: _authOptions,
      );

      print('DOCTOR HISTORY RAW: ${response.data}');

      final List<dynamic> raw = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      final myId = AppPrefs.userId ?? '';

      final serverMessages = raw
          .whereType<Map>()
          .map(
            (e) => DoctorChatMessageModel.fromJson(
              Map<String, dynamic>.from(e),
              myId,
            ),
          )
          .toList();

      final tempMessages = _messages
          .where((m) => m.id.startsWith('temp_'))
          .toList();

      _messages
        ..clear()
        ..addAll(serverMessages);

      for (final temp in tempMessages) {
        final existsOnServer = _messages.any(
          (m) =>
              m.sender == MessageSender.doctor &&
              m.text.trim() == temp.text.trim(),
        );

        if (!existsOnServer) {
          _messages.add(temp);
        }
      }

      if (_isChatOpen && !isClosed) {
        _safeEmit(DoctorChatLoaded(List.from(_messages)));
      }
    } catch (e) {
      print('Doctor silent history error: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty || !_isChatOpen || isClosed) return;

    final tempMsg = DoctorChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: cleanText,
      sender: MessageSender.doctor,
      time: _formatTime(DateTime.now()),
      isRead: false,
    );

    _messages.add(tempMsg);
    _safeEmit(DoctorChatSending(List.from(_messages)));

    try {
      await SignalRService().connect();

      await SignalRService().sendMessage(otherUserId, cleanText);

      print('Doctor sent "$cleanText" to $otherUserId');

      Future.delayed(const Duration(milliseconds: 900), () async {
        if (!_isChatOpen || isClosed) return;
        await _fetchHistorySilently();
      });
    } catch (e) {
      print('DOCTOR SEND ERROR: $e');

      _messages.removeWhere((m) => m.id == tempMsg.id);
      _safeEmit(DoctorChatLoaded(List.from(_messages)));
    }
  }

  void _onSignalRMessage(Map<String, dynamic> data) {
    if (!_isChatOpen || isClosed) return;

    final senderId = (data['senderId'] ?? '').toString();
    final receiverId = (data['receiverId'] ?? '').toString();
    final myId = AppPrefs.userId ?? '';

    final relatedToThisChat =
        senderId == otherUserId || receiverId == otherUserId;

    if (!relatedToThisChat) return;

    final msg = DoctorChatMessageModel.fromSignalR(data, myId);

    if (msg.sender == MessageSender.doctor) {
      _messages.removeWhere(
        (m) =>
            m.id.startsWith('temp_') &&
            m.sender == MessageSender.doctor &&
            m.text.trim() == msg.text.trim(),
      );
    }

    final alreadyExists = _messages.any((m) => m.id == msg.id);

    if (!alreadyExists) {
      _messages.add(msg);
      _safeEmit(DoctorChatLoaded(List.from(_messages)));
    }

    // مهم جدًا:
    // هنا ممنوع نعمل markAsRead.
    // لأن ده كان سبب إن الرسالة تتعلم Seen بعد ثواني حتى والدكتور مش جوه الشات.
  }

  void _onSignalRMessagesRead(String byUserId) {
    if (!_isChatOpen || isClosed) return;
    if (byUserId != otherUserId) return;

    for (int i = 0; i < _messages.length; i++) {
      final msg = _messages[i];

      if (msg.sender == MessageSender.doctor) {
        _messages[i] = DoctorChatMessageModel(
          id: msg.id,
          text: msg.text,
          sender: msg.sender,
          time: msg.time,
          isRead: true,
        );
      }
    }

    _safeEmit(DoctorChatLoaded(List.from(_messages)));
  }

  Future<void> markAsReadOnlyFromVisibleScreen() async {
    if (!_isChatOpen || isClosed) return;

    try {
      await _dio.put(
        "/api/Chat/$otherUserId/read",
        options: _authOptions,
      );

      if (!_isChatOpen || isClosed) return;

      await SignalRService().markAsRead(otherUserId);

      print('Doctor marked as read ONLY from visible screen: $otherUserId');
    } catch (e) {
      print('Doctor markAsRead error: $e');
    }
  }

  void startPolling() {
    _isChatOpen = true;

    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        if (!_isChatOpen || isClosed) return;

        // polling يجيب الرسائل بس
        // ممنوع يعمل Seen
        await _fetchHistorySilently();
      },
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void leaveConversation() {
    _isChatOpen = false;

    stopPolling();

    SignalRService().removeOnMessageReceived(_onSignalRMessage);
    SignalRService().removeOnMessagesRead(_onSignalRMessagesRead);

    print('Doctor left conversation with $otherUserId');
  }

  @override
  Future<void> close() {
    leaveConversation();
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