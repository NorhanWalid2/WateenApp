import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/nurse/layout/widgets/nurse_top_bar_widget.dart';
import '../../data/models/nurse_profile_model.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/contact_info_card_widget.dart';
import 'widgets/qualifications_card_widget.dart';
import 'widgets/certifications_card_widget.dart';
import 'widgets/schedule_card_widget.dart';
import 'widgets/services_card_widget.dart';
import 'widgets/stats_row_widget.dart';

class NurseProfileView extends StatelessWidget {
  final VoidCallback onMenuTap;
  const NurseProfileView({super.key, required this.onMenuTap});

  // TODO: replace with real API data
  static final NurseProfileModel _profile = NurseProfileModel(
    name: 'Fatima Hassan',
    specialty: 'Home Healthcare Specialist',
    rating: 4.8,
    reviewCount: 156,
    yearsExperience: 8,
    email: 'fatima.hassan@wateen.health',
    phone: '+971 55 987 6543',
    serviceArea: 'Dubai, United Arab Emirates',
    qualifications: [
      QualificationModel(
        title: 'Certified Nursing Assistant (CNA)',
        institution: 'Dubai Healthcare Authority (2016)',
      ),
      QualificationModel(
        title: 'Basic Life Support (BLS)',
        institution: 'American Heart Association (2023)',
      ),
      QualificationModel(
        title: 'Home Healthcare Certificate',
        institution: 'Dubai Medical College (2015)',
      ),
    ],
    certifications: [
      CertificationModel(
        title: 'Licensed Healthcare Provider - UAE',
        issuedBy: 'Dubai Health Authority (DHA)',
      ),
      CertificationModel(
        title: 'Infection Prevention & Control',
        issuedBy: 'WHO Certified (2022)',
      ),
      CertificationModel(
        title: 'Patient Safety Certificate',
        issuedBy: 'Joint Commission International',
      ),
    ],
    schedule: [
      ScheduleModel(
        days: 'Monday - Tuesday - Wednesday - Thursday',
        hours: '8:00 AM - 6:00 PM',
      ),
      ScheduleModel(days: 'Friday', hours: '8:00 AM - 2:00 PM'),
      ScheduleModel(days: 'Saturday', hours: '9:00 AM - 3:00 PM'),
      ScheduleModel(days: 'Sunday', hours: '', isClosed: true),
    ],
    servicesOffered: [
      'Vital Monitoring',
      'Medication Administration',
      'Wound Care',
      'Mobility Support',
      'Post-Surgery Care',
      'Elderly Care',
    ],
    totalHomeVisits: 432,
    satisfactionPercent: 96,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            NurseTopBarWidget(onMenuTap: onMenuTap),
            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.archivo(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile header card
                    ProfileHeaderWidget(
                      profile: _profile,
                      onEdit: () {
                        // TODO: navigate to edit profile
                      },
                    ),
                    const SizedBox(height: 16),

                    // Contact info
                    ContactInfoCardWidget(profile: _profile),
                    const SizedBox(height: 16),

                    // Qualifications
                    QualificationsCardWidget(
                      qualifications: _profile.qualifications,
                    ),
                    const SizedBox(height: 16),

                    // Certifications
                    CertificationsCardWidget(
                      certifications: _profile.certifications,
                    ),
                    const SizedBox(height: 16),

                    // Schedule
                    ScheduleCardWidget(schedule: _profile.schedule),
                    const SizedBox(height: 16),

                    // Services
                    ServicesCardWidget(services: _profile.servicesOffered),
                    const SizedBox(height: 16),

                    // Stats
                    StatsRowWidget(
                      totalHomeVisits: _profile.totalHomeVisits,
                      satisfactionPercent: _profile.satisfactionPercent,
                      yearsExperience: _profile.yearsExperience,
                    ),

                    const SizedBox(height: 20),
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
