import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/report_model.dart';
import 'widgets/reports_header_widget.dart';
import 'widgets/report_card_widget.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  // TODO: replace with real API data
  static final List<ReportModel> _reports = [
    ReportModel(
      id: '1',
      patientName: 'Ahmed Al-Mansouri',
      dateTime: '2/6/2026 at 11:49:34 PM',
      location: 'Villa 123, Al Barsha, Dubai',
      vitalsRecorded: true,
      status: 'Completed',
    ),
    ReportModel(
      id: '2',
      patientName: 'Fatima Hassan',
      dateTime: '1/6/2026 at 9:30:00 AM',
      location: 'Jumeirah, Dubai',
      vitalsRecorded: true,
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  Text(
                    'Reports',
                    style: GoogleFonts.archivo(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: _reports.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 56,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No reports yet',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          // Reports summary header
                          ReportsHeaderWidget(
                            totalVisits: _reports.length,
                          ),

                          const SizedBox(height: 16),

                          // Reports list
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _reports.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final report = _reports[index];
                              return ReportCardWidget(
                                report: report,
                                onViewDetails: () {
                                  // TODO: navigate to report details
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}