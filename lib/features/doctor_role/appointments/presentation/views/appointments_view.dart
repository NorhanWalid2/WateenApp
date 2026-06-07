// lib/features/doctor_role/appointments/presentation/views/appointments_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_cubit.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/views/widgets/patient_detail_sheet.dart';

class DoctorAppointmentsView extends StatefulWidget {
  const DoctorAppointmentsView({super.key});

  @override
  State<DoctorAppointmentsView> createState() => _DoctorAppointmentsViewState();
}

class _DoctorAppointmentsViewState extends State<DoctorAppointmentsView> {
  late final DoctorAppointmentsCubit _cubit;
  bool _isUpcomingTab = true;

  @override
  void initState() {
    super.initState();
    _cubit = DoctorAppointmentsCubit()..fetchAppointments();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showPatientSheet(DoctorAppointmentModel appt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PatientDetailSheet(
        patientId: appt.patientId,
        appointmentId: appt.id, // pass appointmentId for Complete button
      ),
    ).then((completed) {
      if (completed == true) {
        // Refresh appointments after completing
        _cubit.fetchAppointments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SafeArea(
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
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
            builder: (context, state) {
              // Get appointments from state
              List<DoctorAppointmentModel> upcoming = [];
              List<DoctorAppointmentModel> completed = [];

              if (state is DoctorAppointmentsLoaded) {
                upcoming = state.appointments
                    .where((a) =>
                        a.status == AppointmentStatus.upcoming ||
                        a.status == AppointmentStatus.pending)
                    .toList();
                completed = state.appointments
                    .where((a) =>
                        a.status == AppointmentStatus.completed ||
                        a.status == AppointmentStatus.cancelled)
                    .toList();
              }

              return Column(
                children: [
                  // ── Header ────────────────────────────────────
                  Container(
                    color: primaryRed,
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Appointments',
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                            GestureDetector(
                              onTap: _cubit.fetchAppointments,
                              child: const Icon(Icons.refresh_rounded,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Tab bar
                        Row(
                          children: [
                            _Tab(
                              label: 'Upcoming',
                              count: upcoming.length,
                              isSelected: _isUpcomingTab,
                              onTap: () =>
                                  setState(() => _isUpcomingTab = true),
                            ),
                            const SizedBox(width: 8),
                            _Tab(
                              label: 'Completed',
                              count: completed.length,
                              isSelected: !_isUpcomingTab,
                              onTap: () =>
                                  setState(() => _isUpcomingTab = false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // ── Body ──────────────────────────────────────
                  Expanded(
                    child: state is DoctorAppointmentsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state is DoctorAppointmentsError
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error_outline_rounded,
                                        size: 48, color: colorScheme.error),
                                    const SizedBox(height: 12),
                                    Text(state.message),
                                    TextButton(
                                      onPressed: _cubit.fetchAppointments,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _buildList(
                                context,
                                _isUpcomingTab ? upcoming : completed,
                                colorScheme,
                                primaryRed,
                              ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DoctorAppointmentModel> list,
      ColorScheme colorScheme, Color primaryRed) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 48, color: colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              _isUpcomingTab
                  ? 'No upcoming appointments'
                  : 'No completed appointments',
              style: TextStyle(color: colorScheme.outlineVariant),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cubit.fetchAppointments,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final appt = list[index];
          return _AppointmentCard(
            appointment: appt,
            primaryRed: primaryRed,
            onTap: () => _showPatientSheet(appt),
          );
        },
      ),
    );
  }
}

// ── Appointment Card ──────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
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
    final isVideo = appointment.type == AppointmentType.videoCall;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  appointment.patientName.isNotEmpty
                      ? appointment.patientName
                          .split(' ')
                          .take(2)
                          .map((p) => p[0])
                          .join()
                          .toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryRed,
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
                  const SizedBox(height: 4),
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
                        '${isVideo ? 'Video' : 'In-person'} · ${appointment.date} ${appointment.time}',
                        style: TextStyle(
                            fontSize: 12, color: colorScheme.outlineVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.reason,
                    style: TextStyle(
                        fontSize: 12, color: colorScheme.outlineVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(Icons.chevron_right_rounded,
                color: colorScheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}

// ── Tab widget ────────────────────────────────────────────────────────────────

class _Tab extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFFDC2626) : Colors.white,
          ),
        ),
      ),
    );
  }
}