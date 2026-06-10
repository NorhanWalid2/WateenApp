// lib/features/doctor_role/dashboard/presentation/views/dashboard_view.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:wateen_app/features/doctor_role/dashboard/data/models/doctor_dashboard_model.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/dashboard/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:wateen_app/features/doctor_role/dashboard/presentation/cubit/doctor_dashboard_state.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/views/widgets/patient_detail_sheet.dart';

class DoctorDashboardView extends StatefulWidget {
  const DoctorDashboardView({super.key});

  @override
  State<DoctorDashboardView> createState() => _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends State<DoctorDashboardView> {
  late final DoctorDashboardCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DoctorDashboardCubit()..fetchDashboard();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _openCalendlyUrl(String url) async {
    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data: url,
        flags: [0x10000000],
      );
      await intent.launch();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _cubit.fetchDashboard,
                child: CustomScrollView(
                  slivers: [
                    // ── Header ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                        decoration: const BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Good ${_greeting()},',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Dr. ${_getDoctorName()}',
                                      style: GoogleFonts.archivo(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ── Stats row ──────────────────────────
                            if (state is DoctorDashboardLoaded)
                              Row(
                                children: [
                                  _StatCard(
                                    value: state.data.todayAppointmentsCount
                                        .toString(),
                                    label: "Today's Appts",
                                    icon: Icons.calendar_today_rounded,
                                  ),
                                  const SizedBox(width: 10),
                                  _StatCard(
                                    value: state.data.totalPatients.toString(),
                                    label: 'Total Patients',
                                    icon: Icons.people_rounded,
                                  ),
                                  const SizedBox(width: 10),
                                  // ✅ FIXED: show totalUpcoming from API
                                  _StatCard(
                                    value: state.data.totalUpcoming.toString(),
                                    label: 'Upcoming',
                                    icon: Icons.event_note_rounded,
                                  ),
                                ],
                              )
                            else
                              Row(
                                children: List.generate(
                                  3,
                                  (_) => Expanded(
                                    child: Container(
                                      height: 70,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // ── Body ─────────────────────────────────────────
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (state is DoctorDashboardError) ...[
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline_rounded,
                                      size: 48, color: colorScheme.error),
                                  const SizedBox(height: 12),
                                  Text(state.message,
                                      style: TextStyle(
                                          color:
                                              colorScheme.onSurfaceVariant)),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: _cubit.fetchDashboard,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          if (state is DoctorDashboardLoading) ...[
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],

                          if (state is DoctorDashboardLoaded) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today's Schedule",
                                  style: GoogleFonts.archivo(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.inverseSurface,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${state.data.todaySchedule.length} appointments',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: primaryRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            if (state.data.todaySchedule.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.event_available_rounded,
                                        size: 44,
                                        color: colorScheme.outlineVariant),
                                    const SizedBox(height: 10),
                                    Text(
                                      'No appointments today',
                                      style: TextStyle(
                                        color: colorScheme.outlineVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...state.data.todaySchedule.map(
                                (appt) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ScheduleCard(
                                    appointment: appt,
                                    onStartMeeting:
                                        appt.calendlyJoinUrl != null
                                            ? () => _openCalendlyUrl(
                                                appt.calendlyJoinUrl!)
                                            : null,
                                    onViewRecord: () async {
                                      final completed =
                                          await showModalBottomSheet<bool>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => PatientDetailSheet(
                                          patientId: appt.patientId,
                                          appointmentId: appt.id,
                                        ),
                                      );
                                      if (completed == true &&
                                          context.mounted) {
                                        _cubit.fetchDashboard();
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String _getDoctorName() {
    if (AppPrefs.userName != null && AppPrefs.userName!.isNotEmpty) {
      return AppPrefs.userName!;
    }
    try {
      final token = AppPrefs.token ?? '';
      if (token.isEmpty) return 'Doctor';
      final parts = token.split('.');
      if (parts.length < 2) return 'Doctor';
      String payload = parts[1];
      while (payload.length % 4 != 0) payload += '=';
      final decoded = String.fromCharCodes(base64Url.decode(payload));
      final Map<String, dynamic> claims = jsonDecode(decoded);
      return (claims['given_name'] ?? claims['name'] ?? claims['unique_name'] ?? 'Doctor').toString();
    } catch (_) {
      return 'Doctor';
    }
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Schedule Card ─────────────────────────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  final TodayAppointmentModel appointment;
  final VoidCallback? onStartMeeting;
  final VoidCallback onViewRecord;

  const _ScheduleCard({
    required this.appointment,
    required this.onStartMeeting,
    required this.onViewRecord,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);
    final isVideo =
        appointment.appointmentType.toLowerCase().contains('video');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    appointment.patientInitials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryRed,
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
                          isVideo ? 'Video Call' : 'In-person',
                          style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.outlineVariant),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time_rounded,
                            size: 13, color: colorScheme.outlineVariant),
                        const SizedBox(width: 4),
                        Text(
                          appointment.time,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(appointment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(appointment.status),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Row(
            children: [
              if (onStartMeeting != null) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: onStartMeeting,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Start Meeting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: GestureDetector(
                  onTap: onViewRecord,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primaryRed.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_rounded,
                            color: primaryRed, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'View Record',
                          style: TextStyle(
                            color: primaryRed,
                            fontSize: 13,
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
      ),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('accept') || s.contains('confirm') || s.contains('upcoming')) {
      return Colors.green;
    }
    if (s.contains('cancel')) return Colors.red;
    if (s.contains('complet')) return Colors.blue;
    return const Color(0xFFF59E0B);
  }
}