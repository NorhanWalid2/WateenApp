import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/features/admin_roles/admin_settings/presentation/views/settings_view.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/cubit/admin_dashboard_cubit.dart';
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
  late final AdminStatsCubit statsCubit; // ✅ added

  @override
  void initState() {
    super.initState();
    doctorCubit = DoctorAdminCubit()..fetchPendingDoctors();
    nurseCubit = NurseAdminCubit()..fetchPendingNurses();
    statsCubit = AdminStatsCubit()..fetchStats();
  }

  @override
  void dispose() {
    doctorCubit.close();
    nurseCubit.close();
    statsCubit.close(); // ✅ dispose it properly
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
    // Refresh stats when returning to dashboard
    if (index == 0) {
      statsCubit.fetchStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: doctorCubit),
        BlocProvider.value(value: nurseCubit),
        BlocProvider.value(value: statsCubit), // ✅ added
      ],
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          if (currentIndex != 0) {
            setState(() => currentIndex = 0);
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: AdminDrawerWidget(
            currentIndex: currentIndex,
            onItemSelected: onNavSelected,
          ),
          body: IndexedStack(
            index: currentIndex,
            children: [
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