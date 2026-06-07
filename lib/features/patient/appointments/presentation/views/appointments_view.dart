import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/appointment_state.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/nurse_requests_view.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/core/widgets/doctor_avatar_widget.dart';
import 'appointment_details_view.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => AppointmentsViewState();
}

class AppointmentsViewState extends State<AppointmentsView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 2 && !tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _openDetails(BuildContext context, AppointmentModel appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsView(appointment: appointment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const primaryRed = Color(0xFFDC2626);

    return BlocProvider(
      create: (_) => AppointmentCubit()..fetchAppointments(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(l10n.appointments,
                    style: textTheme.headlineMedium),
              ),
              const SizedBox(height: 12),

              TabBar(
                controller: tabController,
                labelColor: colorScheme.secondary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.secondary,
                indicatorWeight: 2,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: l10n.upcoming),
                  Tab(text: l10n.past),
                  const Tab(text: 'Nurse Requests'),
                ],
              ),

              Expanded(
                child: BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    // ── Loading ──
                    if (state is AppointmentLoading) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        itemCount: 3,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, __) => const ShimmerListItemWidget(),
                      );
                    }

                    // ── Error ──
                    if (state is AppointmentError) {
                      return Center(
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
                                  .read<AppointmentCubit>()
                                  .fetchAppointments(),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                              style: TextButton.styleFrom(
                                  foregroundColor: colorScheme.secondary),
                            ),
                          ],
                        ),
                      );
                    }

                    // ── Loaded ──
                    final upcoming =
                        state is AppointmentLoaded ? state.upcoming : <AppointmentModel>[];
                    final past =
                        state is AppointmentLoaded ? state.past : <AppointmentModel>[];

                    return TabBarView(
                      controller: tabController,
                      children: [
                        // ── Upcoming ──
                        _buildList(
                          context: context,
                          appointments: upcoming,
                          emptyIcon: Icons.calendar_today_outlined,
                          emptyMessage: 'No upcoming appointments',
                          colorScheme: colorScheme,
                          primaryRed: primaryRed,
                        ),

                        // ── Past ──
                        _buildList(
                          context: context,
                          appointments: past,
                          emptyIcon: Icons.history_rounded,
                          emptyMessage: l10n.noPastAppointments,
                          colorScheme: colorScheme,
                          primaryRed: primaryRed,
                        ),

                        // ── Nurse Requests ──
                        const NurseRequestsView(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList({
    required BuildContext context,
    required List<AppointmentModel> appointments,
    required IconData emptyIcon,
    required String emptyMessage,
    required ColorScheme colorScheme,
    required Color primaryRed,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(emptyMessage,
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: colorScheme.secondary,
      onRefresh: () =>
          context.read<AppointmentCubit>().fetchAppointments(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) => _AppointmentCard(
          appointment: appointments[i],
          primaryRed: primaryRed,
          onTap: () => _openDetails(context, appointments[i]),
        ),
      ),
    );
  }
}

// ── Clean appointment card — no action buttons ────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final Color primaryRed;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.primaryRed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isVideo = appointment.type == AppointmentType.video;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Doctor avatar — shows photo if available
            DoctorAvatarWidget(
              imageUrl: null, // fetched in details view
              initials: appointment.avatarInitials,
              radius: 24,
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.doctorName,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.inverseSurface)),
                  const SizedBox(height: 2),
                  Text(appointment.specialty,
                      style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.outlineVariant)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 13, color: primaryRed),
                      const SizedBox(width: 4),
                      Text(appointment.date,
                          style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.outlineVariant)),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time_rounded,
                          size: 13, color: primaryRed),
                      const SizedBox(width: 4),
                      Text(appointment.time,
                          style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.outlineVariant)),
                    ],
                  ),
                ],
              ),
            ),

            // Type badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVideo
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isVideo ? 'Video' : 'In-person',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isVideo
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF7C3AED),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Icons.chevron_right_rounded,
                    color: colorScheme.outlineVariant, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}