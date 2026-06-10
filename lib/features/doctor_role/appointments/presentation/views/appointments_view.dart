// lib/features/doctor_role/appointments/presentation/views/appointments_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_cubit.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/views/widgets/patient_detail_sheet.dart';

class DoctorAppointmentsView extends StatefulWidget {
  const DoctorAppointmentsView({super.key});

  @override
  State<DoctorAppointmentsView> createState() =>
      _DoctorAppointmentsViewState();
}

class _DoctorAppointmentsViewState extends State<DoctorAppointmentsView>
    with SingleTickerProviderStateMixin {
  late final DoctorAppointmentsCubit _cubit;
  // ✅ Initialized to a dummy length=1 first, replaced in initState
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cubit = DoctorAppointmentsCubit()..fetchAppointments();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _openSheet(DoctorAppointmentModel appt) async {
    final completed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PatientDetailSheet(
        patientId: appt.patientId,
        appointmentId: appt.id,
      ),
    );
    if (completed == true && mounted) {
      _cubit.fetchAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Guard: don't render until tabController is ready
    if (_tabController == null) return const SizedBox.shrink();

    const primaryRed = Color(0xFFDC2626);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DoctorAppointmentsCubit, DoctorAppointmentsState>(
        listener: (context, state) {
          if (state is DoctorAppointmentActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is DoctorAppointmentActionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          // Compute lists once here — used in both header counts and body
          final all = state is DoctorAppointmentsLoaded
              ? state.appointments
              : <DoctorAppointmentModel>[];

          final upcoming = all
              .where((a) =>
                  a.status == AppointmentStatus.upcoming ||
                  a.status == AppointmentStatus.pending)
              .toList();

          final completed = all
              .where((a) => a.status == AppointmentStatus.completed)
              .toList();

          final actingId = state is DoctorAppointmentActionLoading
              ? state.appointmentId
              : null;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    decoration: const BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Appointments',
                              style: GoogleFonts.archivo(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: _cubit.fetchAppointments,
                              child: const Icon(Icons.refresh_rounded,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ✅ TabBar uses the already-initialized controller
                        // counts come from the outer builder — no nested BlocBuilder
                        TabBar(
                          controller: _tabController,
                          labelColor: primaryRed,
                          unselectedLabelColor:
                              Colors.white.withOpacity(0.75),
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                          tabs: [
                            Tab(text: 'Upcoming (${upcoming.length})'),
                            Tab(text: 'Completed (${completed.length})'),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // ── Body ──────────────────────────────────────────
                  Expanded(
                    child: _buildBody(
                      context: context,
                      state: state,
                      upcoming: upcoming,
                      completed: completed,
                      actingId: actingId,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required DoctorAppointmentsState state,
    required List<DoctorAppointmentModel> upcoming,
    required List<DoctorAppointmentModel> completed,
    required String? actingId,
    required ColorScheme colorScheme,
  }) {
    const primaryRed = Color(0xFFDC2626);

    if (state is DoctorAppointmentsLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const ShimmerListItemWidget(),
      );
    }

    if (state is DoctorAppointmentsError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(state.message,
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _cubit.fetchAppointments,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style:
                  TextButton.styleFrom(foregroundColor: primaryRed),
            ),
          ],
        ),
      );
    }

    // ✅ TabBarView uses the same controller — guaranteed initialized
    return TabBarView(
      controller: _tabController,
      children: [
        _buildList(
          appointments: upcoming,
          actingId: actingId,
          isCompleted: false,
          emptyIcon: Icons.calendar_today_outlined,
          emptyMessage: 'No upcoming appointments',
          colorScheme: colorScheme,
        ),
        _buildList(
          appointments: completed,
          actingId: actingId,
          isCompleted: true,
          emptyIcon: Icons.check_circle_outline_rounded,
          emptyMessage: 'No completed appointments',
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildList({
    required List<DoctorAppointmentModel> appointments,
    required String? actingId,
    required bool isCompleted,
    required IconData emptyIcon,
    required String emptyMessage,
    required ColorScheme colorScheme,
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
      color: const Color(0xFFDC2626),
      onRefresh: _cubit.fetchAppointments,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _AppointmentCard(
          appointment: appointments[i],
          isActing: actingId == appointments[i].id,
          isCompleted: isCompleted,
          onViewRecord: isCompleted ? null : () => _openSheet(appointments[i]),
          onComplete: isCompleted
              ? null
              : () => _cubit.completeAppointment(appointments[i].id),
        ),
      ),
    );
  }
}

// ── Appointment Card ──────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isActing;
  final bool isCompleted;
  final VoidCallback? onViewRecord;
  final VoidCallback? onComplete;

  const _AppointmentCard({
    required this.appointment,
    required this.isActing,
    required this.isCompleted,
    this.onViewRecord,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);
    final isVideo = appointment.type == AppointmentType.videoCall;

    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.12)
                      : primaryRed.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initials(appointment.patientName),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? Colors.green : primaryRed,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          isVideo
                              ? Icons.videocam_outlined
                              : Icons.local_hospital_outlined,
                          size: 13,
                          color: colorScheme.outlineVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isVideo ? 'Video' : 'In-Person',
                          style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.outlineVariant),
                        ),
                        if (appointment.time.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.access_time_rounded,
                              size: 13,
                              color: colorScheme.outlineVariant),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${appointment.date}  ${appointment.time}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.outlineVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (appointment.reason.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        appointment.reason,
                        style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.outlineVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      _statusColor(appointment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(appointment.status),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(appointment.status),
                  ),
                ),
              ),
            ],
          ),

          // ── Action buttons (upcoming only) ──────────────────
          if (!isCompleted) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                // View Record
                Expanded(
                  child: GestureDetector(
                    onTap: onViewRecord,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: primaryRed.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open_rounded,
                              color: primaryRed, size: 15),
                          SizedBox(width: 6),
                          Text(
                            'View Record',
                            style: TextStyle(
                              color: primaryRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Mark Complete
                Expanded(
                  child: GestureDetector(
                    onTap: isActing ? null : onComplete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: isActing
                            ? Colors.green.withOpacity(0.5)
                            : Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isActing
                          ? const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white),
                                ),
                                SizedBox(width: 8),
                                Text('Completing...',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 15),
                                SizedBox(width: 6),
                                Text(
                                  'Mark Complete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _statusColor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.upcoming:
        return Colors.green;
      case AppointmentStatus.pending:
        return const Color(0xFFF59E0B);
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  String _statusLabel(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}