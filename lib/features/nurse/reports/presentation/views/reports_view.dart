import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
 import 'package:wateen_app/features/nurse/layout/widgets/nurse_top_bar_widget.dart';
import 'package:wateen_app/features/nurse/reports/presentation/cubit/report_cubit.dart';
import 'package:wateen_app/features/nurse/reports/presentation/cubit/report_state.dart';
import 'package:wateen_app/features/nurse/reports/presentation/views/widgets/report_card_widget.dart';
import '../../data/models/report_model.dart';

class ReportsView extends StatelessWidget {
  final VoidCallback onMenuTap;
  const ReportsView({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit()..fetchMyPatients(),
      child: NurseReportsBody(onMenuTap: onMenuTap), // ← pass it down
    );
  }
}

class NurseReportsBody extends StatelessWidget {
  final VoidCallback onMenuTap;
  const NurseReportsBody({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ─────────────────────────────────────
              NurseTopBarWidget(onMenuTap: onMenuTap),

              // ── Scrollable Content ───────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports',
                        style: textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      if (state is ReportsLoaded)
                        Text(
                          '${state.totalCount} patients served',
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                        ),
                      const SizedBox(height: 20),

                      if (state is ReportsLoading)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, __) => const ShimmerListItemWidget(),
                        )
                      else if (state is ReportsError)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.wifi_off_rounded,
                                    size: 48,
                                    color: colorScheme.onSurfaceVariant),
                                const SizedBox(height: 12),
                                Text(state.message,
                                    style: TextStyle(
                                        color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 16),
                                TextButton.icon(
                                  onPressed: () => context
                                      .read<ReportsCubit>()
                                      .fetchMyPatients(),
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Retry'),
                                  style: TextButton.styleFrom(
                                      foregroundColor: colorScheme.secondary),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (state is ReportsLoaded &&
                          state.patients.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.description_outlined,
                                    size: 56,
                                    color: colorScheme.onSurfaceVariant),
                                const SizedBox(height: 12),
                                Text('No patients yet',
                                    style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                        )
                      else if (state is ReportsLoaded) ...[
                        // ── Summary Card ───────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.people_rounded,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Patients',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${state.totalCount} total served',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Patients List ──────────────────────
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.patients.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => PatientReportCardWidget(
                              patient: state.patients[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}