// lib/features/notifications/presentation/cubit/notification_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/services/notification_signalr_service.dart';
import '../../data/models/notification_model.dart';
import '../../data/repository/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final NotificationRepository _repo = NotificationRepository();
  final NotificationSignalRService _signalR = NotificationSignalRService();

  List<NotificationModel> _cached = [];

  // ── Fetch from REST API ───────────────────────────────────────────
  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      _cached = await _repo.getNotifications();
      emit(NotificationLoaded(_cached));
    } catch (e, s) {
      print('NOTIFICATION FETCH ERROR: $e\n$s');
      emit(NotificationError('Failed to load notifications'));
      return;
    }

    // Connect SignalR separately — never affects loaded state on failure
    try {
      _signalR.addListener(_onRealTimeNotification);
      await _signalR.connect();
      print('NotificationCubit: SignalR ready, isConnected=${_signalR.isConnected}');
    } catch (e) {
      print('NotificationCubit: SignalR connect failed (non-fatal): $e');
    }
  }

  // ── Silent refresh (no loading spinner) ──────────────────────────
  // Called when the user opens the notifications screen again
  Future<void> silentRefresh() async {
    try {
      final fresh = await _repo.getNotifications();
      // Merge: keep any real-time items not yet in the server response
      // by using id as the key and preferring the server version
      final serverIds = fresh.map((n) => n.id).toSet();
      final realTimeOnly = _cached
          .where((n) => !serverIds.contains(n.id))
          .toList();
      _cached = [...realTimeOnly, ...fresh];
      emit(NotificationLoaded(_cached));
    } catch (e) {
      print('NotificationCubit: silentRefresh failed: $e');
      // Don't emit error — keep showing existing data
    }
  }

  // ── Real-time SignalR handler ─────────────────────────────────────
  void _onRealTimeNotification(Map<String, dynamic> data) {
    try {
      print('NotificationCubit: real-time data=$data');
      final newNotification = NotificationModel.fromJson(data);

      // Deduplicate by id only
      if (_cached.any((n) => n.id == newNotification.id)) {
        print('NotificationCubit: duplicate ignored id=${newNotification.id}');
        return;
      }

      // Prepend — newest first
      _cached = [newNotification, ..._cached];
      emit(NotificationLoaded(_cached));
      print('NotificationCubit: ✅ real-time notification added, total=${_cached.length}');
    } catch (e) {
      print('NotificationCubit: real-time parse error $e');
    }
  }

  // ── Mark single as read ───────────────────────────────────────────
  Future<void> markAsRead(String notificationId) async {
    _cached = _cached
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    emit(NotificationLoaded(_cached));
    try {
      await _repo.markAsRead(notificationId);
    } catch (e) {
      print('MARK AS READ ERROR: $e');
      _cached = _cached
          .map((n) => n.id == notificationId ? n.copyWith(isRead: false) : n)
          .toList();
      emit(NotificationLoaded(_cached));
    }
  }

  // ── Mark all as read ──────────────────────────────────────────────
  Future<void> markAllAsRead() async {
    _cached = _cached.map((n) => n.copyWith(isRead: true)).toList();
    emit(NotificationLoaded(_cached));
    try {
      await _repo.markAllAsRead();
    } catch (e) {
      print('MARK ALL READ ERROR: $e');
      fetchNotifications();
    }
  }

  @override
  Future<void> close() {
    _signalR.removeListener(_onRealTimeNotification);
    return super.close();
  }
}