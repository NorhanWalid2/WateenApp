import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/features/admin_roles/admin_settings/presentation/views/settings_view.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/views/dashboard_view.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_cubit.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/views/doctors_management_view.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/views/home_service_management_view.dart';
import 'package:wateen_app/features/admin_roles/patients_management/presentation/views/patients_management_view.dart';
 import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_cubit.dart';
import 'widgets/admin_drawer_widget.dart';

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => AdminMainLayoutState();
}

class AdminMainLayoutState extends State<AdminMainLayout> {
  int currentIndex = 0;
 final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ── Shared cubits — created once, reused across views ────────────
  late final DoctorAdminCubit doctorCubit;
  late final NurseAdminCubit nurseCubit;

  @override
  void initState() {
    super.initState();
    doctorCubit = DoctorAdminCubit()..fetchPendingDoctors();
    nurseCubit = NurseAdminCubit()..fetchPendingNurses();
  }

  @override
  void dispose() {
    doctorCubit.close();
    nurseCubit.close();
    super.dispose();
  }

  void onNavSelected(int index) {
    setState(() => currentIndex = index);
    // Refresh data when navigating to dashboard or management views
    if (index == 0 || index == 1) {
      doctorCubit.fetchPendingDoctors();
    }
    if (index == 0 || index == 3) {
      nurseCubit.fetchPendingNurses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: doctorCubit),
        BlocProvider.value(value: nurseCubit),
      ],
      child: PopScope(
        // ← wrap with PopScope
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          if (currentIndex != 0) {
            // Go back to dashboard instead of closing app
            setState(() => currentIndex = 0);
          }
          // If already on dashboard, do nothing (don't exit)
        },
      child: Scaffold(
         key: scaffoldKey,
        drawer: AdminDrawerWidget(
          currentIndex: currentIndex,
          onItemSelected: onNavSelected,
        ),
        body: IndexedStack(
          index: currentIndex,
          children:   [
            AdminDashboardView(onNavigate: onNavSelected),
            DoctorsManagementView(),
            PatientsManagementView(),
            HomeServiceManagementView(),
            AdminSettingsView(),
          ],
        ),
      ),
      ),
    );
  }
}