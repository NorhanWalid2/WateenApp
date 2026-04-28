import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/admin_roles/all_doctors/data/models/all_doctors_model.dart';
import 'package:wateen_app/features/admin_roles/all_doctors/presentation/cubit/all_doctors_cubit.dart';
import 'package:wateen_app/features/admin_roles/all_doctors/presentation/cubit/all_doctors_states.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/data/models/pending_doctor_model.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_cubit.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_state.dart';

import 'package:wateen_app/features/admin_roles/layout/admin_main_layout.dart';
import 'widgets/pending_doctor_card_widget.dart';

class DoctorsManagementView extends StatelessWidget {
  const DoctorsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AllDoctorsCubit()..fetchDoctors(),
        ),
      ],
      child: const DoctorsManagementBody(),
    );
  }
}

class DoctorsManagementBody extends StatefulWidget {
  const DoctorsManagementBody({super.key});

  @override
  State<DoctorsManagementBody> createState() => DoctorsManagementBodyState();
}

class DoctorsManagementBodyState extends State<DoctorsManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────
            Container(
              color: colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.assetsIconsLogo,
                              width: 32),
                          const SizedBox(width: 8),
                          Text('Wateen', style: textTheme.titleLarge),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          final layoutState = context
                              .findAncestorStateOfType<AdminMainLayoutState>();
                          layoutState?.scaffoldKey.currentState?.openDrawer();
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.menu_rounded,
                              color: colorScheme.inverseSurface, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── TabBar ───────────────────────────────────
                  TabBar(
                    controller: tabController,
                    labelColor: colorScheme.secondary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.secondary,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Pending'),
                      Tab(text: 'All Doctors'),
                    ],
                  ),
                ],
              ),
            ),

            // ── Tab Views ────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // ── Tab 1: Pending Doctors ──────────────────
                  _PendingDoctorsTab(),

                  // ── Tab 2: All Doctors ──────────────────────
                  _AllDoctorsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pending Doctors Tab ───────────────────────────────────────────────────────
class _PendingDoctorsTab extends StatefulWidget {
  @override
  State<_PendingDoctorsTab> createState() => _PendingDoctorsTabState();
}

class _PendingDoctorsTabState extends State<_PendingDoctorsTab> {
  final TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<DoctorAdminCubit, DoctorAdminState>(
      listener: (context, state) {
        if (state is DoctorAdminActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: const Color(0xFF16A34A),
          ));
        } else if (state is DoctorAdminActionError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: colorScheme.error,
          ));
        }
      },
      builder: (context, state) {
        final doctors =
            state is DoctorAdminLoaded ? state.doctors : <PendingDoctorModel>[];
        final filtered = doctors
            .where((d) =>
                query.isEmpty ||
                d.fullName.toLowerCase().contains(query.toLowerCase()) ||
                d.workPlace.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (state is DoctorAdminLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const ShimmerListItemWidget(),
          );
        }

        if (state is DoctorAdminError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(state.message),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () =>
                      context.read<DoctorAdminCubit>().fetchPendingDoctors(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                      foregroundColor: colorScheme.secondary),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doctor Management',
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('${filtered.length} pending approvals',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),

              // ── Search ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: colorScheme.onSurfaceVariant, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) => setState(() => query = v),
                        style: Theme.of(context).textTheme.bodyMedium,
                        cursorColor: colorScheme.secondary,
                        decoration: InputDecoration(
                          hintText: 'Search by name or workplace...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: colorScheme.onSurfaceVariant),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle_outline_rounded,
                                size: 48,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text('No pending doctor approvals',
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          PendingDoctorCardWidget(doctor: filtered[i]),
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ── All Doctors Tab ───────────────────────────────────────────────────────────
class _AllDoctorsTab extends StatefulWidget {
  @override
  State<_AllDoctorsTab> createState() => _AllDoctorsTabState();
}

class _AllDoctorsTabState extends State<_AllDoctorsTab> {
  final TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AllDoctorsCubit, AllDoctorsState>(
      listener: (context, state) {
        if (state is AllDoctorsDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Doctor deleted successfully'),
            backgroundColor: Color(0xFF16A34A),
          ));
        } else if (state is AllDoctorsDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: colorScheme.error,
          ));
        }
      },
      builder: (context, state) {
        final doctors =
            state is AllDoctorsLoaded ? state.doctors : <AllDoctorsModel>[];
        final totalCount = state is AllDoctorsLoaded ? state.totalCount : 0;

        final filtered = doctors
            .where((d) =>
                query.isEmpty ||
                d.fullName.toLowerCase().contains(query.toLowerCase()) ||
                d.specialization
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        if (state is AllDoctorsLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const ShimmerListItemWidget(),
          );
        }

        if (state is AllDoctorsError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(state.message),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () =>
                      context.read<AllDoctorsCubit>().fetchDoctors(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                      foregroundColor: colorScheme.secondary),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All Doctors',
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('$totalCount doctors registered',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),

              // ── Search ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: colorScheme.onSurfaceVariant, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) => setState(() => query = v),
                        style: Theme.of(context).textTheme.bodyMedium,
                        cursorColor: colorScheme.secondary,
                        decoration: InputDecoration(
                          hintText: 'Search by name or specialty...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: colorScheme.onSurfaceVariant),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 48,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text('No doctors found',
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          DoctorCardWidget(doctor: filtered[i]),
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ── Doctor Card Widget ────────────────────────────────────────────────────────
class DoctorCardWidget extends StatelessWidget {
  final AllDoctorsModel doctor;

  const DoctorCardWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AllDoctorsCubit, AllDoctorsState>(
      builder: (context, state) {
        final isDeleting = state is AllDoctorsDeleteLoading &&
            state.doctorId == doctor.id;

        return Container(
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(doctor.initials,
                          style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.fullName,
                            style: textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text(doctor.specialization,
                            style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF16A34A).withOpacity(0.3)),
                    ),
                    child: const Text('Active',
                        style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: colorScheme.outline.withOpacity(0.2)),
              const SizedBox(height: 12),

              _DetailRow(
                icon: Icons.work_outline_rounded,
                label: 'Experience',
                value: '${doctor.experienceYears} years',
              ),
              const SizedBox(height: 6),
              _DetailRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: doctor.phoneNumber,
              ),

              const SizedBox(height: 16),

              isDeleting
                  ? Center(
                      child: CircularProgressIndicator(
                          color: colorScheme.error, strokeWidth: 2))
                  : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteDialog(context),
                        icon: Icon(Icons.delete_outline_rounded,
                            size: 16, color: colorScheme.error),
                        label: Text('Delete Account',
                            style: TextStyle(color: colorScheme.error)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.error),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Doctor'),
        content: Text(
            'Are you sure you want to delete ${doctor.fullName}\'s account? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<AllDoctorsCubit>()
                  .deleteDoctor(doctorId: doctor.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text('$label: ',
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
        Expanded(
          child: Text(value,
              style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.inverseSurface,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}