import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/appointment_card_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/cancel_appointment_dialog.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<AppointmentModel> _upcoming = const [
    AppointmentModel(
      id: '1',
      doctorName: 'Dr. Sarah Johnson',
      specialty: 'General Physician',
      avatarInitials: 'DJ',
      date: 'Today',
      time: '2:30 PM',
      type: AppointmentType.video,
      status: AppointmentStatus.upcoming,
    ),
    AppointmentModel(
      id: '2',
      doctorName: 'Dr. Ahmed Hassan',
      specialty: 'Cardiologist',
      avatarInitials: 'DH',
      date: 'Tomorrow',
      time: '10:00 AM',
      type: AppointmentType.inPerson,
      status: AppointmentStatus.upcoming,
    ),
    AppointmentModel(
      id: '3',
      doctorName: 'Dr. Fatima Hassan',
      specialty: 'Dermatologist',
      avatarInitials: 'DH',
      date: 'Dec 26, 2024',
      time: '11:00 AM',
      type: AppointmentType.message,
      status: AppointmentStatus.upcoming,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Appointments', style: textTheme.headlineMedium),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Tabs ─────────────────────────────
            TabBar(
              controller: _tabController,
              labelColor: colorScheme.secondary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.secondary,
              indicatorWeight: 2,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')],
            ),

            // ── Tab Content ──────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: _upcoming.length,
                    itemBuilder:
                        (ctx, i) => AppointmentCardWidget(
                          appointment: _upcoming[i],
                          onTap:
                              () => CustomNavigation(
                                context,
                                '/appointmentsDetails',
                              ),
                          onAction: () {},
                          onReschedule:
                              () => CustomNavigation(
                                context,
                                '/rescheduleAppointments',
                              ),
                          onCancel:
                              () => showDialog(
                                context: context,
                                builder:
                                    (_) => CancelAppointmentDialog(
                                      onConfirm: () => Navigator.pop(context),
                                      onGoBack: () => Navigator.pop(context),
                                    ),
                              ),
                        ),
                  ),
                  // Past
                  const Center(child: Text('No past appointments')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
