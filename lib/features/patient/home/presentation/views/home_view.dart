import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/greeting_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/section_header_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/home_appointment_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/medication_reminder_card_widget.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/quick_action_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GreetingCardWidget(name: 'Ahmed Al-Mansouri'),
          const SizedBox(height: 20),

          SectionHeaderWidget(
            title: 'Next Appointment',
            actionLabel: 'View All',
            onTap: () {
              return CustomNavigation(context, '/appointments');
            },
          ),
          const SizedBox(height: 10),
          HomeAppointmentCardWidget(
            doctorName: 'Dr. Sarah Ahmed',
            specialty: 'Cardiologist',
            dateTime: 'Today, 2:30 PM',
            onViewDetails: () {
              return CustomNavigation(context, '/appointmentsDetails');
            },
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

          const SectionHeaderWidget(title: 'Quick Actions'),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              QuickActionCardWidget(
                action: QuickActionModel(
                  icon: Icons.calendar_today_rounded,
                  label: 'My Appointments',
                  subtitle: 'View & manage',
                  color: Colors.blue,
                  onTap: () {
                    return CustomNavigation(context, '/appointments');
                  },
                ),
              ),
              QuickActionCardWidget(
                action: QuickActionModel(
                  icon: Icons.local_hospital_rounded,
                  label: 'Book Doctor',
                  subtitle: 'Schedule appointment',
                  color: Colors.green,
                  onTap: () {},
                ),
              ),
              QuickActionCardWidget(
                action: QuickActionModel(
                  icon: Icons.medical_services_rounded,
                  label: 'Request Nurse',
                  subtitle: 'Home care service',
                  color: Colors.purple,
                  onTap: () {},
                ),
              ),
              QuickActionCardWidget(
                action: QuickActionModel(
                  icon: Icons.restaurant_rounded,
                  label: 'Scan Meal',
                  subtitle: 'Check nutrition',
                  color: Colors.orange,
                  onTap: () {},
                ),
              ),
              QuickActionCardWidget(
                action: QuickActionModel(
                  icon: Icons.monitor_heart_rounded,
                  label: 'Add Vitals',
                  subtitle: 'Log health data',
                  color: Colors.red,
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
