import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';

import 'package:wateen_app/features/admin_roles/homeService_management/data/models/all_nurses_model.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/data/models/pending_nurse_model.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/all_nurses_cubit.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/all_nurses_state.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_cubit.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_state.dart';
import 'package:wateen_app/features/admin_roles/layout/admin_main_layout.dart';
import 'widgets/pending_nurse_card_widget.dart';

class HomeServiceManagementView extends StatelessWidget {
  const HomeServiceManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllNursesCubit()..fetchNurses(),
      child: const HomeServiceManagementBody(),
    );
  }
}

class HomeServiceManagementBody extends StatefulWidget {
  const HomeServiceManagementBody({super.key});

  @override
  State<HomeServiceManagementBody> createState() =>
      HomeServiceManagementBodyState();
}

class HomeServiceManagementBodyState extends State<HomeServiceManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
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
                          SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
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
                          layoutState?.scaffoldKey.currentState?.openDrawer();
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
                  const SizedBox(height: 16),
                  TabBar(
                    controller: tabController,
                    labelColor: colorScheme.secondary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.secondary,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [Tab(text: 'Pending'), Tab(text: 'All Nurses')],
                  ),
                ],
              ),
            ),

            // ── Tab Views ────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [_PendingNursesTab(), _AllNursesTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pending Nurses Tab ────────────────────────────────────────────────────────
class _PendingNursesTab extends StatefulWidget {
  @override
  State<_PendingNursesTab> createState() => _PendingNursesTabState();
}

class _PendingNursesTabState extends State<_PendingNursesTab> {
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

    return BlocConsumer<NurseAdminCubit, NurseAdminState>(
      listener: (context, state) {
        if (state is NurseAdminActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
        } else if (state is NurseAdminActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final nurses =
            state is NurseAdminLoaded ? state.nurses : <PendingNurseModel>[];
        final filtered =
            nurses
                .where(
                  (n) =>
                      query.isEmpty ||
                      n.fullName.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

        if (state is NurseAdminLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const ShimmerListItemWidget(),
          );
        }

        if (state is NurseAdminError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(state.message),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed:
                      () =>
                          context.read<NurseAdminCubit>().fetchPendingNurses(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.secondary,
                  ),
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
              Text(
                'Home Service Management',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${filtered.length} pending approvals',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // ── Search ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) => setState(() => query = v),
                        cursorColor: colorScheme.secondary,
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          hintStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
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
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 48,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No pending nurse approvals',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder:
                        (_, i) => PendingNurseCardWidget(nurse: filtered[i]),
                  ),
            ],
          ),
        );
      },
    );
  }
}

// ── All Nurses Tab ────────────────────────────────────────────────────────────
class _AllNursesTab extends StatefulWidget {
  @override
  State<_AllNursesTab> createState() => _AllNursesTabState();
}

class _AllNursesTabState extends State<_AllNursesTab> {
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

    return BlocConsumer<AllNursesCubit, AllNursesState>(
      listener: (context, state) {
        if (state is AllNursesDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nurse deleted successfully'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
        } else if (state is AllNursesDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final nurses =
            state is AllNursesLoaded ? state.nurses : <AllNursesModel>[];
        final totalCount = state is AllNursesLoaded ? state.totalCount : 0;

        final filtered =
            nurses
                .where(
                  (n) =>
                      query.isEmpty ||
                      n.fullName.toLowerCase().contains(query.toLowerCase()) ||
                      n.specialization.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();

        if (state is AllNursesLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const ShimmerListItemWidget(),
          );
        }

        if (state is AllNursesError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(state.message),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => context.read<AllNursesCubit>().fetchNurses(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.secondary,
                  ),
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
              Text(
                'All Nurses',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalCount nurses registered',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // ── Search ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) => setState(() => query = v),
                        cursorColor: colorScheme.secondary,
                        decoration: InputDecoration(
                          hintText: 'Search by name or specialty...',
                          hintStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
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
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No nurses found',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => NurseCardWidget(nurse: filtered[i]),
                  ),
            ],
          ),
        );
      },
    );
  }
}

// ── Nurse Card Widget ─────────────────────────────────────────────────────────
class NurseCardWidget extends StatelessWidget {
  final AllNursesModel nurse;

  const NurseCardWidget({super.key, required this.nurse});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AllNursesCubit, AllNursesState>(
      builder: (context, state) {
        final isDeleting =
            state is AllNursesDeleteLoading && state.nurseId == nurse.id;

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
              // ── Header ──────────────────────────────────────
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
                      child: Text(
                        nurse.initials,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nurse.fullName,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          nurse.specialization,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF16A34A).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: colorScheme.outline.withOpacity(0.2)),
              const SizedBox(height: 12),

              // ── Details ──────────────────────────────────────
              _NurseDetailRow(
                icon: Icons.work_outline_rounded,
                label: 'Experience',
                value: '${nurse.experienceYears} years',
              ),
              const SizedBox(height: 6),
              _NurseDetailRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: nurse.phoneNumber,
              ),

              const SizedBox(height: 16),

              // ── Delete Button ─────────────────────────────────
              isDeleting
                  ? Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.error,
                      strokeWidth: 2,
                    ),
                  )
                  : SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showDeleteDialog(context),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      label: Text(
                        'Delete Account',
                        style: TextStyle(color: colorScheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Nurse'),
            content: Text(
              'Are you sure you want to delete ${nurse.fullName}\'s account? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AllNursesCubit>().deleteNurse(nurseId: nurse.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}

class _NurseDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _NurseDetailRow({
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
        Text(
          '$label: ',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.inverseSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
