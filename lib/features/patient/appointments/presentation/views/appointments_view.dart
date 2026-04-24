import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/nurse_requests_view.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/appointment_card_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/cancel_appointment_dialog.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => AppointmentsViewState();
}

class AppointmentsViewState extends State<AppointmentsView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<AppointmentModel> upcoming = const [
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
  tabController = TabController(length: 3, vsync: this);
  tabController.addListener(() {
    if (tabController.index == 2 && !tabController.indexIsChanging) {
      setState(() {}); // rebuild NurseRequestsView → re-fetches
    }
  });
}

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
              child: TabBarView(
                controller: tabController,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    itemCount: upcoming.length,
                    itemBuilder: (ctx, i) => AppointmentCardWidget(
                      appointment: upcoming[i],
                      onTap: () =>
                          CustomNavigation(context, '/appointmentsDetails'),
                      onAction: () {},
                      onReschedule: () =>
                          CustomNavigation(context, '/rescheduleAppointments'),
                      onCancel: () => showDialog(
                        context: context,
                        builder: (_) => CancelAppointmentDialog(
                          onConfirm: () => Navigator.pop(context),
                          onGoBack: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  Center(child: Text(l10n.noPastAppointments)),
                  const NurseRequestsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}