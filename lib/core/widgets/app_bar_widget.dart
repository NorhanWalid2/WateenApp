import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:wateen_app/features/notifications/presentation/cubit/notification_state.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final canPop = context.canPop();

    // Null-safe — only patient layout provides NotificationCubit
    final notifCubit = context.read<NotificationCubit?>();
    final unread = notifCubit != null &&
            context.watch<NotificationCubit>().state is NotificationLoaded
        ? (context.watch<NotificationCubit>().state as NotificationLoaded)
            .unreadCount
        : 0;

    return Row(
      children: [
        if (canPop)
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        if (!canPop) const SizedBox(width: 12),
        SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
        const SizedBox(width: 8),
        Text(l10n.wateen, style: textTheme.titleLarge),
        const Spacer(),

        if (notifCubit != null)
          GestureDetector(
            onTap: () {
              // ✅ Mark all as read BEFORE navigating — badge clears instantly
              notifCubit.markAllAsRead();
              context.push('/notifications');
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    unread > 0
                        ? Icons.notifications_rounded
                        : Icons.notifications_none_rounded,
                    size: 22,
                    color: unread > 0
                        ? const Color(0xFFDC2626)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints: const BoxConstraints(
                          minWidth: 18, minHeight: 18),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unread > 99 ? '99+' : unread.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}