import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/views/appointments_view.dart';
import 'package:wateen_app/features/doctor_role/dashboard/presentation/views/dashboard_view.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/doctor_role/messages_/presentation/views/doctor_messages_view.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/views/patients_view.dart';
import 'widgets/doctor_bottom_nav_widget.dart';

class DoctorMainLayout extends StatefulWidget {
  const DoctorMainLayout({super.key});

  @override
  State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
}

class _DoctorMainLayoutState extends State<DoctorMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DoctorDashboardView(),
    DoctorPatientsView(),
    DoctorAppointmentsView(),
    DoctorMessagesView(),
    DoctorProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: DoctorBottomNavWidget(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}