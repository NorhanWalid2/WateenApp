// lib/features/doctor_role/messages_/presentation/cubit/doctor_conversatonal_cubit.dart

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/services/signalr_service.dart';
import 'package:wateen_app/features/doctor_role/messages_/data/models/doctor_conversational_model.dart';
import 'package:wateen_app/features/doctor_role/messages_/presentation/cubit/doctor_conversational_state.dart';

class DoctorConversationsCubit extends Cubit<DoctorConversationsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  Timer? _pollingTimer;

  DoctorConversationsCubit() : super(DoctorConversationsInitial()) {
    // ✅ Use addOn* — never overwrite other cubits' callbacks
    SignalRService().addOnMessageReceived(_onNewMessage);
    SignalRService().addOnMessagesRead(_onMessagesRead);
    startPolling();
  }

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  void _safeEmit(DoctorConversationsState state) {
    if (!isClosed) emit(state);
  }

  // ── SignalR callbacks ─────────────────────────────────────────────

  void _onNewMessage(Map<String, dynamic> data) {
    print('DoctorConversations: new message received, refreshing list');
    _silentRefresh();
  }

  void _onMessagesRead(String byUserId) {
    print('DoctorConversations: messages read by $byUserId');
    _silentRefresh();
  }

  // ── Extract list from paginated API response ──────────────────────

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['data'] is List) return responseData['data'];
      if (responseData['conversations'] is List) return responseData['conversations'];
      if (responseData['items'] is List) return responseData['items'];
    }
    return [];
  }

  // ── Fetch conversations ───────────────────────────────────────────

  Future<void> fetchConversations() async {
    _safeEmit(DoctorConversationsLoading());
    try {
      await SignalRService().connect();

      final response = await _dio.get("/api/Chat", options: _authOptions);
      final data = _extractList(response.data);

      final conversations = data
          .whereType<Map>()
          .map((e) => DoctorConversationModel.fromJson(
                Map<String, dynamic>.from(e)))
          .where((c) => c.lastMessage.trim().isNotEmpty)
          .toList();

      _safeEmit(DoctorConversationsLoaded(conversations));
    } on DioException catch (e) {
      print('CONVERSATIONS ERROR: ${e.response?.data}');
      _safeEmit(DoctorConversationsError(
        e.response?.data?['message'] ?? 'Failed to load conversations',
      ));
    } catch (e) {
      print('CONVERSATIONS CATCH: $e');
      _safeEmit(DoctorConversationsError('Something went wrong'));
    }
  }

  // ── Silent refresh — no loading state ────────────────────────────

  Future<void> _silentRefresh() async {
    if (isClosed) return;
    try {
      final response = await _dio.get("/api/Chat", options: _authOptions);
      final data = _extractList(response.data);

      final conversations = data
          .whereType<Map>()
          .map((e) => DoctorConversationModel.fromJson(
                Map<String, dynamic>.from(e)))
          .where((c) => c.lastMessage.trim().isNotEmpty)
          .toList();

      if (!isClosed) _safeEmit(DoctorConversationsLoaded(conversations));
    } catch (e) {
      print('Doctor conversations silent refresh error: $e');
    }
  }

  // ── Mark as read ──────────────────────────────────────────────────

  Future<void> markAsRead(String otherUserId) async {
    try {
      await _dio.put("/api/Chat/$otherUserId/read", options: _authOptions);
      await SignalRService().markAsRead(otherUserId);
      await _silentRefresh();
    } catch (e) {
      print('MARK READ ERROR: $e');
    }
  }

  // ── Polling ───────────────────────────────────────────────────────

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _silentRefresh(),
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    // ✅ Remove listeners when cubit is disposed
    SignalRService().removeOnMessageReceived(_onNewMessage);
    SignalRService().removeOnMessagesRead(_onMessagesRead);
    stopPolling();
    return super.close();
  }
}