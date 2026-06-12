import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:wateen_app/features/notifications/presentation/cubit/notification_state.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class GreetingCardWidget extends StatelessWidget {
  final String name;
  const GreetingCardWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch the shared cubit from PatientMainLayout
    final notifState = context.watch<NotificationCubit>().state;
    final unread = notifState is NotificationLoaded ? notifState.unreadCount : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary,
            colorScheme.secondary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.goodMorning,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ── Notification Bell ──────────────────────────────
          // GestureDetector(
          //   onTap: () {
          //     // ✅ Mark all as read BEFORE navigating — clears badge immediately
          //     context.read<NotificationCubit>().markAllAsRead();
          //     context.push('/notifications');
          //   },
          //   child: Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //       Container(
          //         width: 46,
          //         height: 46,
          //         decoration: BoxDecoration(
          //           color: Colors.white.withOpacity(0.2),
          //           shape: BoxShape.circle,
          //           border: Border.all(
          //             color: Colors.white.withOpacity(0.3),
          //             width: 1.2,
          //           ),
          //         ),
          //         child: Icon(
          //           unread > 0
          //               ? Icons.notifications_rounded
          //               : Icons.notifications_none_rounded,
          //           color: Colors.white,
          //           size: 24,
          //         ),
          //       ),
          //       if (unread > 0)
          //         Positioned(
          //           top: -4,
          //           right: -4,
          //           child: Container(
          //             padding: const EdgeInsets.all(2),
          //             constraints: const BoxConstraints(
          //                 minWidth: 20, minHeight: 20),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black.withOpacity(0.15),
          //                   blurRadius: 4,
          //                   offset: const Offset(0, 1),
          //                 ),
          //               ],
          //             ),
          //             child: Center(
          //               child: Text(
          //                 unread > 99 ? '99+' : unread.toString(),
          //                 style: TextStyle(
          //                   color: colorScheme.secondary,
          //                   fontSize: 10,
          //                   fontWeight: FontWeight.w800,
          //                   height: 1,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}