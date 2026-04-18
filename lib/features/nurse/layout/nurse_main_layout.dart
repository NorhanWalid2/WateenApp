import 'package:flutter/material.dart';
import 'package:wateen_app/features/nurse/home/presentation/views/home_view.dart';
import 'package:wateen_app/features/nurse/active_visit/presentation/views/active_visit_view.dart';
import 'package:wateen_app/features/nurse/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/nurse/reports/presentation/views/reports_view.dart';

class NurseMainLayout extends StatefulWidget {
  const NurseMainLayout({super.key});

  @override
  State<NurseMainLayout> createState() => _NurseMainLayoutState();
}

class _NurseMainLayoutState extends State<NurseMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    NurseHomeView(),
    ActiveVisitView(),
    ReportsView(),
    NurseProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.outlineVariant,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            activeIcon: Icon(Icons.list_alt_rounded),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on_rounded),
            label: 'Active Visit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
