import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/quick_action_grid_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/greeting_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/section_header_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/home_appointment_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/medication_reminder_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GreetingCardWidget(name: 'Ahmed Al-Mansouri'),
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
            onMarkAsTaken: () {},
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
  }
}
