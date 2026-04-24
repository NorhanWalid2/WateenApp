import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/contact_info_card_widget.dart';
import 'widgets/qualifications_card_widget.dart';
import 'widgets/certifications_card_widget.dart';
import 'widgets/schedule_card_widget.dart';
import 'widgets/expertise_card_widget.dart';
import 'widgets/stats_row_widget.dart';
import 'widgets/update_schedule_sheet_widget.dart';

class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({super.key});

  @override
  State<DoctorProfileView> createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {

  // TODO: replace with real API data
  late DoctorProfileModel _profile = DoctorProfileModel(
    name: 'Dr. Sarah Ahmed',
    specialty: 'Cardiologist',
    rating: 4.9,
    reviewCount: 245,
    yearsExperience: 12,
    email: 'dr.sarah.ahmed@wateen.health',
    phone: '+971 50 123 4567',
    location: 'Wateen Medical Center, Dubai Healthcare City',
    qualifications: [
      DoctorQualificationModel(
        degree: 'MD in Cardiology',
        institution: 'Harvard Medical School, USA (2014)',
      ),
      DoctorQualificationModel(
        degree: 'MBBS',
        institution: 'Dubai Medical College (2010)',
      ),
      DoctorQualificationModel(
        degree: 'Fellowship in Interventional Cardiology',
        institution: 'Johns Hopkins Hospital (2016)',
      ),
    ],
    certifications: [
      DoctorCertificationModel(
        title: 'Board Certified Cardiologist',
        issuedBy: 'American Board of Internal Medicine',
      ),
      DoctorCertificationModel(
        title: 'Advanced Cardiac Life Support (ACLS)',
        issuedBy: 'American Heart Association',
      ),
      DoctorCertificationModel(
        title: 'Licensed Physician - UAE',
        issuedBy: 'Dubai Health Authority (DHA)',
      ),
    ],
    schedule: [
      DoctorScheduleModel(
        days: 'Monday - Tuesday - Wednesday',
        startTime: '9:00 AM',
        endTime: '5:00 PM',
        isEnabled: true,
      ),
      DoctorScheduleModel(
        days: 'Thursday - Friday',
        startTime: '9:00 AM',
        endTime: '2:00 PM',
        isEnabled: true,
      ),
      DoctorScheduleModel(
        days: 'Saturday',
        startTime: '10:00 AM',
        endTime: '4:00 PM',
        isEnabled: true,
      ),
      DoctorScheduleModel(
        days: 'Sunday',
        startTime: '',
        endTime: '',
        isEnabled: false,
      ),
    ],
    areasOfExpertise: [
      'Heart Disease',
      'Hypertension',
      'Arrhythmia',
      'Heart Failure',
      'Preventive Cardiology',
      'Echocardiography',
    ],
    totalPatients: 1234,
    successRate: 98,
  );

  void _showUpdateSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UpdateScheduleSheetWidget(
        schedule: _profile.schedule,
        onSave: (updated) {
          setState(() {
            _profile = DoctorProfileModel(
              name: _profile.name,
              specialty: _profile.specialty,
              rating: _profile.rating,
              reviewCount: _profile.reviewCount,
              yearsExperience: _profile.yearsExperience,
              email: _profile.email,
              phone: _profile.phone,
              location: _profile.location,
              qualifications: _profile.qualifications,
              certifications: _profile.certifications,
              schedule: updated,
              areasOfExpertise: _profile.areasOfExpertise,
              totalPatients: _profile.totalPatients,
              successRate: _profile.successRate,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [

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

                    // Profile header
                    DoctorProfileHeaderWidget(
                      profile: _profile,
                      onEdit: () {
                        // TODO: navigate to edit profile
                      },
                    ),
                    const SizedBox(height: 16),

                    // Contact info
                    DoctorContactInfoCardWidget(profile: _profile),
                    const SizedBox(height: 16),

                    // Qualifications
                    DoctorQualificationsCardWidget(
                      qualifications: _profile.qualifications,
                    ),
                    const SizedBox(height: 16),

                    // Certifications
                    DoctorCertificationsCardWidget(
                      certifications: _profile.certifications,
                    ),
                    const SizedBox(height: 16),

                    // Schedule
                    DoctorScheduleCardWidget(
                      schedule: _profile.schedule,
                      onUpdate: _showUpdateSchedule,
                    ),
                    const SizedBox(height: 16),

                    // Expertise
                    DoctorExpertiseCardWidget(
                      expertise: _profile.areasOfExpertise,
                    ),
                    const SizedBox(height: 16),

                    // Stats
                    DoctorStatsRowWidget(
                      totalPatients: _profile.totalPatients,
                      successRate: _profile.successRate,
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