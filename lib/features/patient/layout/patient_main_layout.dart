import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/ai_assistant_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointments_view.dart';
import 'package:wateen_app/features/patient/health/presentation/views/health_view.dart';
import 'package:wateen_app/features/patient/home/presentation/views/home_view.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/conversations_view.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/layout/widgets/nav_item_widget.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';

class PatientMainLayout extends StatefulWidget {
  const PatientMainLayout({super.key});

  @override
  State<PatientMainLayout> createState() => PatientMainLayoutState();
}

class PatientMainLayoutState extends State<PatientMainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeView(),
    AppointmentsView(),
    ConversationsView(),
    HealthView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: AppBarWidget(),
          ),
        ),
      ),

      body: IndexedStack(index: currentIndex, children: screens),

      // ── FAB على اليمين ──────────────────────
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiAssistantView()),
                ),
            backgroundColor: colorScheme.secondary,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),

      // ── Bottom Nav ──────────────────────────
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.primary,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          CircleBorder(),
        ),
        notchMargin: 8,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItemWidget(
                icon: Icons.home_rounded,
                label: l10n.home,
                isSelected: currentIndex == 0,
                onTap: () => setState(() => currentIndex = 0),
              ),
              NavItemWidget(
                icon: Icons.calendar_today_rounded,
                label: l10n.appointments,
                isSelected: currentIndex == 1,
                onTap: () => setState(() => currentIndex = 1),
              ),
              NavItemWidget(
                icon: Icons.chat_bubble_outline_rounded,
                label: l10n.messages,
                isSelected: currentIndex == 2,
                onTap: () => setState(() => currentIndex = 2),
              ),
              NavItemWidget(
                icon: Icons.favorite_rounded,
                label: l10n.health,
                isSelected: currentIndex == 3,
                onTap: () => setState(() => currentIndex = 3),
              ),
              NavItemWidget(
                icon: Icons.person_rounded,
                label: l10n.profile,
                isSelected: currentIndex == 4,
                onTap: () => setState(() => currentIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
