// lib/features/doctor_role/appointments/presentation/views/appointments_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_cubit.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart';
import 'package:wateen_app/features/doctor_role/doctor_calendy/presentation/views/widgets/manage_availability_banner_widget.dart';
import 'widgets/appointment_card_widget.dart';
import 'widgets/appointment_details_sheet_widget.dart';

class DoctorAppointmentsView extends StatelessWidget {
  const DoctorAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAppointmentsCubit()..fetchAppointments(),
      child: const _DoctorAppointmentsBody(),
    );
  }
}

class _DoctorAppointmentsBody extends StatefulWidget {
  const _DoctorAppointmentsBody();

  @override
  State<_DoctorAppointmentsBody> createState() =>
      _DoctorAppointmentsBodyState();
}

class _DoctorAppointmentsBodyState extends State<_DoctorAppointmentsBody> {
  bool _isUpcomingTab = true;

  void _showDetails(DoctorAppointmentModel appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<DoctorAppointmentsCubit>(),
        child: AppointmentDetailsSheetWidget(appointment: appointment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: BlocConsumer<DoctorAppointmentsCubit, DoctorAppointmentsState>(
          listener: (context, state) {
            if (state is DoctorAppointmentActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is DoctorAppointmentActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
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
                      // Refresh button
                      GestureDetector(
                        onTap: () => context
                            .read<DoctorAppointmentsCubit>()
                            .fetchAppointments(),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Tab bar ────────────────────────────────────────────────
                Container(
                  color: colorScheme.primary,
                  child: Row(
                    children: [
                      _TabButton(
                        label: 'Upcoming',
                        isSelected: _isUpcomingTab,
                        onTap: () => setState(() => _isUpcomingTab = true),
                      ),
                      _TabButton(
                        label: 'Completed',
                        isSelected: !_isUpcomingTab,
                        onTap: () => setState(() => _isUpcomingTab = false),
                      ),
                    ],
                  ),
                ),
ManageAvailabilityBannerWidget(
  onTap: () => context.push('/doctorCalendly'),
),
                // ── Body ───────────────────────────────────────────────────
                Expanded(
                  child: switch (state) {
                    DoctorAppointmentsLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    DoctorAppointmentsError(:final message) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: colorScheme.error,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context
                                  .read<DoctorAppointmentsCubit>()
                                  .fetchAppointments(),
                              child: Text(
                                'Retry',
                                style:
                                    TextStyle(color: colorScheme.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    DoctorAppointmentsLoaded(:final upcoming, :final completed) =>
                      _buildList(
                        context,
                        _isUpcomingTab ? upcoming : completed,
                        colorScheme,
                      ),
                    // Action loading / success / error — keep showing last list
                    _ => _buildList(context, [], colorScheme),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<DoctorAppointmentModel> list,
    ColorScheme colorScheme,
  ) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 48,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 12),
            Text(
              _isUpcomingTab
                  ? 'No upcoming appointments'
                  : 'No completed appointments',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<DoctorAppointmentsCubit>().fetchAppointments(),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final appointment = list[index];
          return AppointmentCardWidget(
            appointment: appointment,
            onTap: () => _showDetails(appointment),
          );
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? colorScheme.secondary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}