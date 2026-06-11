// lib/features/notifications/presentation/views/notification_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:wateen_app/features/notifications/presentation/cubit/notification_state.dart';
import 'package:wateen_app/features/notifications/data/models/notification_model.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with WidgetsBindingObserver {
  late final NotificationCubit _cubit;
  bool _ownsCubit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final parentCubit = context.read<NotificationCubit?>();
    if (parentCubit != null) {
      _cubit = parentCubit;
      _ownsCubit = false;
    } else {
      _cubit = NotificationCubit()..fetchNotifications();
      _ownsCubit = true;
    }
    // Bell already called markAllAsRead before navigating here.
    // Just fetch/refresh to get latest data.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.silentRefresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_ownsCubit) _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cubit.silentRefresh();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      _cubit.silentRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFDC2626);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(                           // ✅ was missing
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                decoration: const BoxDecoration(
                  color: primaryRed,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.archivo(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        BlocBuilder<NotificationCubit, NotificationState>(
                          builder: (context, state) {
                            final unread = state is NotificationLoaded
                                ? state.unreadCount
                                : 0;
                            return Text(
                              unread > 0
                                  ? '$unread unread'
                                  : 'All caught up',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        final hasUnread = state is NotificationLoaded &&
                            state.unreadCount > 0;
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () => _cubit.fetchNotifications(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.refresh_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                            if (hasUnread) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _cubit.markAllAsRead(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Mark all read',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Body ──────────────────────────────────────────
              Expanded(
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: primaryRed, strokeWidth: 2),
                      );
                    }

                    if (state is NotificationError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off_rounded,
                                size: 48,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text(state.message,
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => _cubit.fetchNotifications(),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                              style: TextButton.styleFrom(
                                  foregroundColor: primaryRed),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is NotificationLoaded) {
                      if (state.notifications.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.notifications_none_rounded,
                                  size: 64,
                                  color: colorScheme.onSurfaceVariant),
                              const SizedBox(height: 12),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: primaryRed,
                        onRefresh: () => _cubit.fetchNotifications(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: state.notifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) => _NotificationCard(
                            notification: state.notifications[i],
                            onTap: state.notifications[i].isRead
                                ? null
                                : () => _cubit.markAsRead(
                                    state.notifications[i].id),
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const _NotificationCard({required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);
    final icon = _iconForType(notification.type);
    final iconColor = _colorForType(notification.type);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? colorScheme.primary
              : primaryRed.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: notification.isRead
              ? null
              : Border.all(color: primaryRed.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                      if (!notification.isRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: primaryRed, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _labelForType(notification.type),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: iconColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.outlineVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'reminder':    return Icons.medication_rounded;
      case 'appointment': return Icons.calendar_today_rounded;
      default:            return Icons.notifications_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'reminder':    return const Color(0xFF8B5CF6);
      case 'appointment': return const Color(0xFF0EA5E9);
      default:            return const Color(0xFFF59E0B);
    }
  }

  String _labelForType(String type) {
    switch (type.toLowerCase()) {
      case 'reminder':    return 'Reminder';
      case 'appointment': return 'Appointment';
      default:            return 'System';
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}