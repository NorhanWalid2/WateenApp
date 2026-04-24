import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/appointment_model.dart';
import 'widgets/appointment_card_widget.dart';
import 'widgets/appointment_details_sheet_widget.dart';

class DoctorAppointmentsView extends StatefulWidget {
  const DoctorAppointmentsView({super.key});

  @override
  State<DoctorAppointmentsView> createState() =>
      _DoctorAppointmentsViewState();
}

class _DoctorAppointmentsViewState extends State<DoctorAppointmentsView> {
  bool _isUpcomingTab = true;

  // TODO: replace with real API data
  final List<DoctorAppointmentModel> _appointments = [
    DoctorAppointmentModel(
      id: '1',
      patientName: 'Ahmed Al-Mansouri',
      patientAge: 54,
      date: 'Tuesday, January 27',
      time: '10:00 AM',
      reason: 'Blood pressure checkup',
      type: AppointmentType.inPerson,
      status: AppointmentStatus.upcoming,
      patientId: '1',
    ),
    DoctorAppointmentModel(
      id: '2',
      patientName: 'Fatima Hassan',
      patientAge: 42,
      date: 'Tuesday, January 27',
      time: '2:30 PM',
      reason: 'Asthma follow-up',
      type: AppointmentType.videoCall,
      status: AppointmentStatus.upcoming,
      patientId: '2',
    ),
    DoctorAppointmentModel(
      id: '3',
      patientName: 'Mohammed Ali',
      patientAge: 38,
      date: 'Wednesday, January 28',
      time: '11:00 AM',
      reason: 'Cholesterol review',
      type: AppointmentType.inPerson,
      status: AppointmentStatus.upcoming,
      patientId: '3',
    ),
    DoctorAppointmentModel(
      id: '4',
      patientName: 'Layla Ahmed',
      patientAge: 29,
      date: 'Monday, January 20',
      time: '9:00 AM',
      reason: 'Annual checkup',
      type: AppointmentType.inPerson,
      status: AppointmentStatus.completed,
      patientId: '4',
    ),
  ];

  List<DoctorAppointmentModel> get _upcomingAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.upcoming)
      .toList();

  List<DoctorAppointmentModel> get _completedAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.completed)
      .toList();

  void _showDetails(DoctorAppointmentModel appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppointmentDetailsSheetWidget(
        appointment: appointment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList =
        _isUpcomingTab ? _upcomingAppointments : _completedAppointments;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointments',
                    style: GoogleFonts.archivo(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Tabs ──
                  Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          label: 'Upcoming',
                          isActive: _isUpcomingTab,
                          onTap: () =>
                              setState(() => _isUpcomingTab = true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TabButton(
                          label: 'Completed',
                          isActive: !_isUpcomingTab,
                          onTap: () =>
                              setState(() => _isUpcomingTab = false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── List ──
            Expanded(
              child: displayList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No ${_isUpcomingTab ? 'upcoming' : 'completed'} appointments',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: displayList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final appointment = displayList[index];
                        return AppointmentCardWidget(
                          appointment: appointment,
                          onTap: () => _showDetails(appointment),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}