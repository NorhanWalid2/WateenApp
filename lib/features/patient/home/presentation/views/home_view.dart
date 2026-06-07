import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/appointment_state.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointment_details_view.dart';
import 'package:wateen_app/features/patient/home/presentation/cubit/home_cubit.dart';
import 'package:wateen_app/features/patient/home/presentation/cubit/home_state.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/quick_action_grid_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/greeting_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/section_header_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/home_appointment_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/medication_reminder_card_widget.dart';
import 'package:wateen_app/core/widgets/doctor_avatar_widget.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<HomeViewBodyState>? bodyKey;
  const HomeView({super.key, this.bodyKey});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..fetchPatientProfile()),
        BlocProvider(create: (_) => AppointmentCubit()..fetchAppointments()),
      ],
      child: HomeViewBody(key: bodyKey),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => HomeViewBodyState();
}

class HomeViewBodyState extends State<HomeViewBody> {
  void refreshProfile() {
    context.read<HomeCubit>().fetchPatientProfile();
    context.read<AppointmentCubit>().fetchAppointments();
  }

  Future<void> _openVideoCall(String url) async {
    try {
      final intent = AndroidIntent(
          action: 'action_view', data: url, flags: [0x10000000]);
      await intent.launch();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        final String displayName =
            homeState is HomeLoaded ? homeState.profile.fullName : '';

        return BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, apptState) {
            // Get the first upcoming appointment sorted by date
            AppointmentModel? nextAppointment;
            if (apptState is AppointmentLoaded &&
                apptState.upcoming.isNotEmpty) {
              final sorted = List<AppointmentModel>.from(apptState.upcoming);
              // Sort by date — earliest first
              // AppointmentModel has date as string, so we use the raw
              // appointmentTime stored in the cubit API response
              nextAppointment = sorted.first;
            }

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Greeting ─────────────────────────────────────
                  if (homeState is HomeLoading)
                    const GreetingShimmerWidget()
                  else
                    GreetingCardWidget(
                      name: displayName.isNotEmpty ? displayName : '...',
                    ),

                  const SizedBox(height: 20),

                  // ── Next Appointment ──────────────────────────────
                  SectionHeaderWidget(
                    title: l10n.nextAppointment,
                    actionLabel: l10n.viewAll,
                    onTap: () => CustomNavigation(context, '/appointments'),
                  ),
                  const SizedBox(height: 10),

                  if (apptState is AppointmentLoading)
                    // Loading skeleton
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                          child: CircularProgressIndicator()),
                    )
                  else if (nextAppointment != null)
                    // ✅ Real appointment from API
                    _NextAppointmentCard(
                      appointment: nextAppointment,
                      onViewDetails: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentDetailsView(
                              appointment: nextAppointment!),
                        ),
                      ),
                      onStart: nextAppointment.videoCallLink != null &&
                              nextAppointment.videoCallLink!.isNotEmpty
                          ? () =>
                              _openVideoCall(nextAppointment!.videoCallLink!)
                          : null,
                    )
                  else
                    // No upcoming appointments
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 36,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant),
                          const SizedBox(height: 8),
                          Text(
                            'No upcoming appointments',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => CustomNavigation(
                                context, '/bookAppointment'),
                            child: Text('Book Now',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ── Medication Reminder (still hardcoded) ─────────
                  MedicationReminderCardWidget(
                    medicationName: 'Metformin 500mg',
                    instructions: 'Take 1 tablet after breakfast',
                    onMarkAsTaken: () {},
                    onRemindLater: () {},
                  ),

                  const SizedBox(height: 20),

                  // ── Quick Actions ─────────────────────────────────
                  SectionHeaderWidget(title: l10n.quickActions),
                  const SizedBox(height: 12),
                  const QuickActionsGridWidget(),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Next Appointment Card ─────────────────────────────────────────────────────

class _NextAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onViewDetails;
  final VoidCallback? onStart;

  const _NextAppointmentCard({
    required this.appointment,
    required this.onViewDetails,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isVideo = appointment.type == AppointmentType.video;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Doctor avatar
              DoctorAvatarWidget(
                imageUrl: null, // will show once doctor profile picture flows
                initials: appointment.avatarInitials,
                radius: 24,
                backgroundColor:
                    colorScheme.secondary.withOpacity(0.15),
                initialsColor: colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.doctorName,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(appointment.specialty,
                      style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14, color: colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        '${appointment.date} · ${appointment.time}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isVideo
                      ? const Color(0xFFEFF6FF)
                      : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isVideo ? 'Video' : 'In-person',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isVideo
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.secondary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (onStart != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.videocam_rounded,
                        color: Colors.white, size: 18),
                    label: const Text('Start',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Greeting shimmer ──────────────────────────────────────────────────────────

class GreetingShimmerWidget extends StatelessWidget {
  const GreetingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary,
            colorScheme.secondary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 12, width: 80,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 8),
          Container(height: 18, width: 180,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6))),
        ],
      ),
    );
  }
}