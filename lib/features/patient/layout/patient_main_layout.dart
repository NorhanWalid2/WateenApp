import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/ai_assistant_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointments_view.dart';
import 'package:wateen_app/features/patient/health/presentation/views/health_view.dart';
import 'package:wateen_app/features/patient/home/presentation/views/home_view.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/layout/widgets/nav_item_widget.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';

class PatientMainLayout extends StatefulWidget {
  const PatientMainLayout({super.key});

  @override
  State<PatientMainLayout> createState() => _PatientMainLayoutState();
}

class _PatientMainLayoutState extends State<PatientMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeView(),
    AppointmentsView(),
    HealthView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ── Shared AppBar ───────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: AppBarWidget(),
          ),
        ),
      ),

      // ── Screen Content ──────────────────────
      body: IndexedStack(index: _currentIndex, children: _screens),

      // ── Bottom Nav ──────────────────────────
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.primary,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: // في PatientMainLayout، عدّل الـ Row داخل BottomAppBar:
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItemWidget(
                icon: Icons.home_rounded,
                label: l10n.home,
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              NavItemWidget(
                icon: Icons.calendar_today_rounded,
                label: l10n.appointments,
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),

              // ── Gap for FAB ─────────────────
              const SizedBox(width: 72), // ← كبّر الـ width من 56 لـ 72

              NavItemWidget(
                icon: Icons.monitor_heart_rounded,
                label: l10n.health,
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              NavItemWidget(
                icon: Icons.person_rounded,
                label: l10n.profile,
                isSelected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AiAssistantView()),
          );
        },
        backgroundColor: colorScheme.secondary,
        elevation: 4,
        shape: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 26),
            // Text(
            //   l10n.aiAssistant,
            //   style: textTheme.bodySmall?.copyWith(
            //     fontSize: 10,
            //     color: colorScheme.onPrimary,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
