import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/doctor_dashboard_model.dart';
import 'widgets/stats_card_widget.dart';
import 'widgets/alert_card_widget.dart';
import 'widgets/schedule_card_widget.dart';

class DoctorDashboardView extends StatelessWidget {
  const DoctorDashboardView({super.key});

  static final DoctorDashboardStatsModel _stats = DoctorDashboardStatsModel(
    todayAppointments: 12,
    alerts: 3,
    totalPatients: 45,
  );

  static final List<PatientAlertModel> _alerts = [
    PatientAlertModel(
      id: '1',
      patientName: 'Ahmed Al-Mansouri',
      message: 'Abnormal vitals: Blood pressure: 145/95 mmHg',
      type: AlertType.critical,
    ),
    PatientAlertModel(
      id: '2',
      patientName: 'Fatima Hassan',
      message: 'Missed medication: Has not taken insulin for 2 days',
      type: AlertType.warning,
    ),
  ];

  static final List<ScheduleItemModel> _schedule = [
    ScheduleItemModel(
      id: '1',
      patientName: 'Mohammed Rashid',
      visitType: 'Follow-up',
      time: '10:30 AM',
      initial: 'M',
    ),
    ScheduleItemModel(
      id: '2',
      patientName: 'Layla Ahmed',
      visitType: 'Consultation',
      time: '11:00 AM',
      initial: 'L',
    ),
    ScheduleItemModel(
      id: '3',
      patientName: 'Omar Khalil',
      visitType: 'Check-up',
      time: '2:00 PM',
      initial: 'O',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Blue Header ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor name + specialty
                    Text(
                      'Dr. Sarah Johnson',
                      style: GoogleFonts.archivo(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'General Physician',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats row
                    Row(
                      children: [
                        DoctorStatsCardWidget(
                          value: _stats.todayAppointments.toString(),
                          label: "Today's Appts",
                        ),
                        const SizedBox(width: 10),
                        DoctorStatsCardWidget(
                          value: _stats.alerts.toString(),
                          label: 'Alerts',
                        ),
                        const SizedBox(width: 10),
                        DoctorStatsCardWidget(
                          value: _stats.totalPatients.toString(),
                          label: 'Total Patients',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Patient Alerts ──
                    Text(
                      'Patient Alerts',
                      style: GoogleFonts.archivo(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _alerts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return AlertCardWidget(
                          alert: _alerts[index],
                          onViewDetails: () {
                            // TODO: navigate to patient details
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── Today's Schedule ──
                    Text(
                      "Today's Schedule",
                      style: GoogleFonts.archivo(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _schedule.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return ScheduleCardWidget(
                          item: _schedule[index],
                          onStartCall: () {
                            // TODO: start call
                          },
                          onViewRecords: () {
                            // TODO: navigate to patient details
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}