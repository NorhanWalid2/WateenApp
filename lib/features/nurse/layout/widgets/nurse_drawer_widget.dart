import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/services/signalr_service.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_cubit.dart';

class NurseDrawerWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const NurseDrawerWidget({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      backgroundColor: colorScheme.primary,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
                      const SizedBox(width: 8),
                      Text('Wateen', style: textTheme.titleLarge),
                      const SizedBox(width: 8),
                      Text(
                        'Nurse Portal',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: colorScheme.outline.withOpacity(0.3), height: 1),
            const SizedBox(height: 8),

            // ── Nav Items ─────────────────────────────────────────
            NurseDrawerItemWidget(
              icon: Icons.list_alt_rounded,
              label: 'Requests',
              isActive: currentIndex == 0,
              onTap: () {
                onItemSelected(0);
                Navigator.pop(context);
              },
            ),
          
            NurseDrawerItemWidget(
              icon: Icons.description_outlined,
              label: 'Reports',
              isActive: currentIndex == 1,
              onTap: () {
                onItemSelected(1);
                Navigator.pop(context);
              },
            ),
            NurseDrawerItemWidget(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              isActive: currentIndex == 2,
              onTap: () {
                onItemSelected(2);
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            Divider(color: colorScheme.outline.withOpacity(0.3), height: 1),

            // ── Logout ────────────────────────────────────────────
            NurseDrawerItemWidget(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              isActive: false,
              isLogout: true,
              onTap: () async {
                Navigator.pop(context);
                ChatCubit().clearCache();
                await SignalRService().disconnect();
                await AppPrefs.clearAll();
                if (context.mounted) context.go('/login');
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class NurseDrawerItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLogout;
  final VoidCallback onTap;

  const NurseDrawerItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? Colors.white
                  : isLogout
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? Colors.white
                    : isLogout
                        ? colorScheme.error
                        : colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}