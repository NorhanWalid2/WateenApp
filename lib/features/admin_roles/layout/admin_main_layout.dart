import 'package:flutter/material.dart';
import 'package:wateen_app/features/admin_roles/admin_settings/presentation/views/settings_view.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/views/dashboard_view.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/views/doctors_management_view.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/views/home_service_management_view.dart';
import 'package:wateen_app/features/admin_roles/patients_management/presentation/views/patients_management_view.dart';
import 'widgets/admin_drawer_widget.dart';

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AdminDashboardView(),
    DoctorsManagementView(),
    PatientsManagementView(),
    HomeServiceManagementView(),
    AdminSettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawerWidget(
        currentIndex: _currentIndex,
        onItemSelected: (index) => setState(() => _currentIndex = index),
      ),
      body: _screens[_currentIndex],
    );
  }
}
