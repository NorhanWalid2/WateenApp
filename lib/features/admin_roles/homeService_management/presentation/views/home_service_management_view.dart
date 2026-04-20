import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/data/models/pending_nurse_model.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_cubit.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/cubit/nurse_admin_state.dart';
import 'widgets/pending_nurse_card_widget.dart';

class HomeServiceManagementView extends StatelessWidget {
  const HomeServiceManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeServiceManagementBody();
  }
}

class HomeServiceManagementBody extends StatefulWidget {
  const HomeServiceManagementBody({super.key});

  @override
  State<HomeServiceManagementBody> createState() =>
      HomeServiceManagementBodyState();
}

class HomeServiceManagementBodyState extends State<HomeServiceManagementBody> {
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

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: Column(
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
                          SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
                          const SizedBox(width: 8),

                          // ── App Name ─────────────────────────
                          Text('Wateen', style: textTheme.titleLarge),
                        ],
                      ),

                      // Hamburger menu
                      GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.menu_rounded,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      state is NurseAdminLoading
                          ? ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: 3,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 12),
                            itemBuilder:
                                (_, __) => const ShimmerListItemWidget(),
                          )
                          : state is NurseAdminError
                          ? Center(
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
                                          context
                                              .read<NurseAdminCubit>()
                                              .fetchPendingNurses(),
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Retry'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : SingleChildScrollView(
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

                                // ── Search ──────────────────────
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
                                          onChanged:
                                              (v) => setState(() => query = v),
                                          style: textTheme.bodyMedium,
                                          decoration: InputDecoration(
                                            hintText: 'Search by name...',
                                            hintStyle: textTheme.bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      colorScheme
                                                          .onSurfaceVariant,
                                                ),
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 40,
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              size: 48,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'No pending nurse approvals',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme
                                                            .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filtered.length,
                                      separatorBuilder:
                                          (_, __) => const SizedBox(height: 12),
                                      itemBuilder:
                                          (_, i) => PendingNurseCardWidget(
                                            nurse: filtered[i],
                                          ),
                                    ),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
