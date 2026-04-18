import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/home/presentation/cubit/home_cubit.dart';
import 'package:wateen_app/features/patient/home/presentation/cubit/home_state.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/quick_action_grid_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/greeting_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/section_header_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/home_appointment_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/medication_reminder_card_widget.dart';

class HomeView extends StatelessWidget {
  // ✅ bodyKey goes to HomeViewBody, NOT to HomeView itself
  final GlobalKey<HomeViewBodyState>? bodyKey;

  const HomeView({super.key, this.bodyKey});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..fetchPatientProfile(),
      child: HomeViewBody(key: bodyKey), // ✅ key only here
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final String displayName =
            state is HomeLoaded ? state.profile.fullName : '';

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is HomeLoading)
                const GreetingShimmerWidget()
              else
                GreetingCardWidget(
                  name: displayName.isNotEmpty ? displayName : '...',
                ),

              const SizedBox(height: 20),

              SectionHeaderWidget(
                title: l10n.nextAppointment,
                actionLabel: l10n.viewAll,
                onTap: () => CustomNavigation(context, '/appointments'),
              ),
              const SizedBox(height: 10),
              HomeAppointmentCardWidget(
                doctorName: 'Dr. Sarah Ahmed',
                specialty: 'Cardiologist',
                dateTime: 'Today, 2:30 PM',
                onViewDetails:
                    () => CustomNavigation(context, '/appointmentsDetails'),
                onStart: () {},
              ),

              const SizedBox(height: 20),

              MedicationReminderCardWidget(
                medicationName: 'Metformin 500mg',
                instructions: 'Take 1 tablet after breakfast',
                onMarkAsTaken: () async {
                  await AppPrefs.clearToken();
                  CustomReplacementNavigation(context, '/login');
                },
                onRemindLater: () {},
              ),

              const SizedBox(height: 20),

              SectionHeaderWidget(title: l10n.quickActions),
              const SizedBox(height: 12),
              const QuickActionsGridWidget(),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

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
          Container(
            height: 12,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 18,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
