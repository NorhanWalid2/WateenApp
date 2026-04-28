import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/core/widgets/shimmer_widget.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/cubit/admin_dashboard_state.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/views/widgets/stats_card_widget.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_cubit.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_state.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_cubit.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_state.dart';
import 'package:wateen_app/features/admin_roles/layout/admin_main_layout.dart';
import 'widgets/quick_action_button_widget.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/views/widgets/pending_doctor_card_widget.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/views/widgets/pending_nurse_card_widget.dart';

class AdminDashboardView extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

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
                      color: colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.assetsIconsLogo,
                                width: 32,
                              ),
                              const SizedBox(width: 8),
                              Text('Wateen', style: textTheme.titleLarge),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
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

                            BlocBuilder<AdminStatsCubit, AdminStatsState>(
                              builder: (context, statsState) {
                                final isStatsLoading =
                                    statsState is AdminStatsLoading;
                                final stats =
                                    statsState is AdminStatsLoaded
                                        ? statsState
                                        : null;

                                final cards = [
                                  AdminStatCardWidget(
                                    icon: Icons.people_rounded,
                                    iconColor: const Color(0xFF3B82F6),
                                    iconBg: const Color(0xFFEFF6FF),
                                    label: 'Total Users',
                                    value:
                                        isStatsLoading
                                            ? '...'
                                            : '${stats?.usersCount ?? 0}',
                                  ),
                                  AdminStatCardWidget(
                                    icon: Icons.medical_services_rounded,
                                    iconColor: const Color(0xFF16A34A),
                                    iconBg: const Color(0xFFECFDF5),
                                    label: 'Doctors',
                                    value:
                                        isStatsLoading
                                            ? '...'
                                            : '${stats?.doctorsCount ?? 0}',
                                  ),
                                  AdminStatCardWidget(
                                    icon: Icons.home_outlined,
                                    iconColor: colorScheme.secondary,
                                    iconBg: colorScheme.secondary.withOpacity(
                                      0.1,
                                    ),
                                    label: 'Nurses',
                                    value:
                                        isStatsLoading
                                            ? '...'
                                            : '${stats?.nursesCount ?? 0}',
                                  ),
                                  AdminStatCardWidget(
                                    icon: Icons.person_rounded,
                                    iconColor: const Color(0xFFF59E0B),
                                    iconBg: const Color(0xFFFFFBEB),
                                    label: 'Patients',
                                    value:
                                        isStatsLoading
                                            ? '...'
                                            : '${stats?.patientsCount ?? 0}',
                                  ),
                                ];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Overview',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: cards.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            mainAxisExtent: 150,
                                          ),
                                      itemBuilder: (_, index) => cards[index],
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              },
                            ),
                            

                            const SizedBox(height: 24),

                            if (isLoading) ...[
                              const ShimmerWidget(width: 120, height: 16),
                              const SizedBox(height: 12),
                              const ShimmerListItemWidget(),
                              const SizedBox(height: 24),
                              const ShimmerWidget(width: 120, height: 16),
                              const SizedBox(height: 12),
                              const ShimmerListItemWidget(),
                            ],

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
                                  _CountBadge(
                                    text: '${pendingDoctors.length} pending',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              PendingDoctorCardWidget(
                                doctor: pendingDoctors[0],
                              ),
                              if (pendingDoctors.length > 1) ...[
                                const SizedBox(height: 8),
                                _ViewAllButton(
                                  text:
                                      'View All ${pendingDoctors.length} Doctors',
                                  onTap: () {
                                    final layoutState =
                                        context
                                            .findAncestorStateOfType<
                                              AdminMainLayoutState
                                            >();
                                    layoutState?.onNavSelected(1);
                                  },
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],

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
                                  _CountBadge(
                                    text: '${pendingNurses.length} pending',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              PendingNurseCardWidget(nurse: pendingNurses[0]),
                              if (pendingNurses.length > 1) ...[
                                const SizedBox(height: 8),
                                _ViewAllButton(
                                  text:
                                      'View All ${pendingNurses.length} Nurses',
                                  onTap: () {
                                    final layoutState =
                                        context
                                            .findAncestorStateOfType<
                                              AdminMainLayoutState
                                            >();
                                    layoutState?.onNavSelected(3);
                                  },
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],

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
                                      const Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 56,
                                        color: Color(0xFF16A34A),
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

class _PendingCountCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String? value;
  final String label;

  const _PendingCountCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 125,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          value == null
              ? const ShimmerWidget(width: 50, height: 28)
              : Text(
                value!,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final String text;

  const _CountBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colorScheme.secondary,
        ),
      ),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ViewAllButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
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
    );
  }
}
