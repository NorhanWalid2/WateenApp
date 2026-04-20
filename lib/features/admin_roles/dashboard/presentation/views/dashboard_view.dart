import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/core/widgets/shimmer_widget.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_cubit.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_state.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_cubit.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_state.dart';
import 'package:wateen_app/features/admin_roles/layout/admin_main_layout.dart';
import 'widgets/quick_action_button_widget.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/views/widgets/pending_doctor_card_widget.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/views/widgets/pending_nurse_card_widget.dart';

class AdminDashboardView extends StatelessWidget {
  final ValueChanged<int>? onNavigate; // ← add

  const AdminDashboardView({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return AdminDashboardBody(onNavigate: onNavigate);
  }
}

class AdminDashboardBody extends StatelessWidget {
  final ValueChanged<int>? onNavigate;
  const AdminDashboardBody({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<DoctorAdminCubit, DoctorAdminState>(
          builder: (context, doctorState) {
            return BlocBuilder<NurseAdminCubit, NurseAdminState>(
              builder: (context, nurseState) {
                final pendingDoctors =
                    doctorState is DoctorAdminLoaded ? doctorState.doctors : [];
                final pendingNurses =
                    nurseState is NurseAdminLoaded ? nurseState.nurses : [];

                final isLoading =
                    doctorState is DoctorAdminLoading ||
                    nurseState is NurseAdminLoading;
                return Column(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Wateen Logo
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.assetsIconsLogo,
                                width: 32,
                              ),
                              const SizedBox(width: 8),

                              // ── App Name ─────────────────────────
                              Text('Wateen', style: textTheme.titleLarge),
                            ],
                          ),

                          // Hamburger menu
                          GestureDetector(
                            onTap: () {
                              // Find the AdminMainLayout's scaffold key and open drawer
                              final layoutState =
                                  context
                                      .findAncestorStateOfType<
                                        AdminMainLayoutState
                                      >();
                              layoutState?.scaffoldKey.currentState
                                  ?.openDrawer();
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.menu_rounded,
                                color: colorScheme.inverseSurface,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Title ──────────────────────────────────
                            Text(
                              'Dashboard',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Welcome to Wateen Healthcare Admin Portal',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ── Pending Count Cards ─────────────────────
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.medical_services_rounded,
                                            color: Color(0xFF3B82F6),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        isLoading
                                            ? const ShimmerWidget(
                                              width: 50,
                                              height: 28,
                                            )
                                            : Text(
                                              '${pendingDoctors.length}',
                                              style: textTheme.headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Pending Doctors',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: colorScheme.secondary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.home_outlined,
                                            color: colorScheme.secondary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        isLoading
                                            ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : Text(
                                              '${pendingNurses.length}',
                                              style: textTheme.headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Pending Nurses',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            // After the count cards Row, add:
                            if (isLoading) ...[
                              const ShimmerWidget(width: 120, height: 16),
                              const SizedBox(height: 12),
                              const ShimmerListItemWidget(),
                              const SizedBox(height: 24),
                              const ShimmerWidget(width: 120, height: 16),
                              const SizedBox(height: 12),
                              const ShimmerListItemWidget(),
                            ],
                            // ── Pending Doctors ─────────────────────────────────
                            if (pendingDoctors.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pending Doctors',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${pendingDoctors.length} pending',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // ── Show only first doctor ──────────────────────
                              PendingDoctorCardWidget(
                                doctor: pendingDoctors[0],
                              ),

                              // ── View All button ─────────────────────────────
                              if (pendingDoctors.length > 1) ...[
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    final layoutState =
                                        context
                                            .findAncestorStateOfType<
                                              AdminMainLayoutState
                                            >();
                                    layoutState?.onNavSelected(1);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.secondary
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'View All ${pendingDoctors.length} Doctors',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.secondary,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 16,
                                          color: colorScheme.secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],

                            // ── Pending Nurses ──────────────────────────────────
                            if (pendingNurses.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pending Nurses',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${pendingNurses.length} pending',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // ── Show only first nurse ───────────────────────
                              PendingNurseCardWidget(nurse: pendingNurses[0]),

                              // ── View All button ─────────────────────────────
                              if (pendingNurses.length > 1) ...[
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    final layoutState =
                                        context
                                            .findAncestorStateOfType<
                                              AdminMainLayoutState
                                            >();
                                    layoutState?.onNavSelected(3);
                                  },

                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.secondary
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'View All ${pendingNurses.length} Nurses',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.secondary,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 16,
                                          color: colorScheme.secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],
                            // ── Empty state ─────────────────────────────
                            if (!isLoading &&
                                pendingDoctors.isEmpty &&
                                pendingNurses.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 56,
                                        color: const Color(0xFF16A34A),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'All caught up!',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'No pending approvals at the moment',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            // ── Quick Actions ───────────────────────────
                            Text(
                              'Quick Actions',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            QuickActionButtonWidget(
                              icon: Icons.medical_services_rounded,
                              title: 'Review Doctor Applications',
                              subtitle: '${pendingDoctors.length} pending',
                              onTap: () {
                                final layoutState =
                                    context
                                        .findAncestorStateOfType<
                                          AdminMainLayoutState
                                        >();
                                layoutState?.onNavSelected(1);
                              },
                            ),
                            const SizedBox(height: 10),
                            QuickActionButtonWidget(
                              icon: Icons.home_outlined,
                              title: 'Review Nurse Applications',
                              subtitle: '${pendingNurses.length} pending',
                              onTap: () {
                                final layoutState =
                                    context
                                        .findAncestorStateOfType<
                                          AdminMainLayoutState
                                        >();
                                layoutState?.onNavSelected(3);
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
