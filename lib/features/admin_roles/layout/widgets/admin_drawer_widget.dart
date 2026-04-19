import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDrawerWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const AdminDrawerWidget({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Column(
          children: [

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Wateen',
                          style: GoogleFonts.archivo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Admin Portal',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              color: Theme.of(context).colorScheme.surface,
              thickness: 1,
            ),

            const SizedBox(height: 8),

            // ── Nav Items ──
            _DrawerItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              isActive: currentIndex == 0,
              onTap: () {
                onItemSelected(0);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.medical_services_rounded,
              label: 'Doctors',
              isActive: currentIndex == 1,
              onTap: () {
                onItemSelected(1);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.people_rounded,
              label: 'Patients',
              isActive: currentIndex == 2,
              onTap: () {
                onItemSelected(2);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.home_rounded,
              label: 'Home Service',
              isActive: currentIndex == 3,
              onTap: () {
                onItemSelected(3);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              isActive: currentIndex == 4,
              onTap: () {
                onItemSelected(4);
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            Divider(
              color: Theme.of(context).colorScheme.surface,
              thickness: 1,
            ),

            // ── Log Out ──
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              isActive: false,
              isLogout: true,
              onTap: () {
                Navigator.pop(context);
                // TODO: connect logout logic
                context.go('/login');
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLogout;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
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
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? Colors.white
                    : isLogout
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}