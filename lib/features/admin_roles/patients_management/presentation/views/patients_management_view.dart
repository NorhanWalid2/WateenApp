import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/patient_management_model.dart';
import 'widgets/patient_stats_card_widget.dart';
import 'widgets/patient_management_card_widget.dart';

class PatientsManagementView extends StatefulWidget {
  const PatientsManagementView({super.key});

  @override
  State<PatientsManagementView> createState() => _PatientsManagementViewState();
}

class _PatientsManagementViewState extends State<PatientsManagementView> {
  final TextEditingController _searchController = TextEditingController();

  // TODO: replace with real API data
  static final PatientStatsModel _stats = PatientStatsModel(
    totalPatients: 1248,
    activeThisMonth: 847,
    newThisWeek: 42,
  );

  final List<PatientManagementModel> _allPatients = [
    PatientManagementModel(
      id: '1',
      name: 'Ahmed Al-Mansouri',
      gender: 'Male',
      email: 'ahmed.mansouri@email.com',
      phone: '+971 50 123 4567',
      lastVisit: '2024-01-20',
      appointmentsCount: 12,
    ),
    PatientManagementModel(
      id: '2',
      name: 'Fatima Ibrahim',
      gender: 'Female',
      email: 'fatima.ibrahim@email.com',
      phone: '+971 50 234 5678',
      lastVisit: '2024-01-22',
      appointmentsCount: 8,
    ),
    PatientManagementModel(
      id: '3',
      name: 'Omar Hassan',
      gender: 'Male',
      email: 'omar.hassan@email.com',
      phone: '+971 50 345 6789',
      lastVisit: '2024-01-19',
      appointmentsCount: 15,
    ),
    PatientManagementModel(
      id: '4',
      name: 'Noura Al-Rashid',
      gender: 'Female',
      email: 'noura.rashid@email.com',
      phone: '+971 50 456 7890',
      lastVisit: '2024-01-18',
      appointmentsCount: 5,
    ),
  ];

  List<PatientManagementModel> get _filteredPatients {
    return _allPatients.where((patient) {
      return _searchController.text.isEmpty ||
          patient.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          patient.email.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Wateen',
                      style: GoogleFonts.archivo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        size: 20,
                      ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Patient Management',
                      style: GoogleFonts.archivo(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View and manage registered patients',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Stats Cards ──
                    PatientStatsCardWidget(
                      icon: Icons.people_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      iconBgColor: const Color(0xFFEFF6FF),
                      label: 'Total Patients',
                      value: _stats.totalPatients.toString(),
                    ),
                    const SizedBox(height: 12),
                    PatientStatsCardWidget(
                      icon: Icons.calendar_month_rounded,
                      iconColor: const Color(0xFF16A34A),
                      iconBgColor: const Color(0xFFECFDF5),
                      label: 'Active This Month',
                      value: _stats.activeThisMonth.toString(),
                    ),
                    const SizedBox(height: 12),
                    PatientStatsCardWidget(
                      icon: Icons.person_add_rounded,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      iconBgColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      label: 'New This Week',
                      value: _stats.newThisWeek.toString(),
                    ),

                    const SizedBox(height: 20),

                    // ── Search ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.outlineVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search patients by name or email...',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Patients List ──
                    _filteredPatients.isEmpty
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No patients found',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredPatients.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final patient = _filteredPatients[index];
                            return PatientManagementCardWidget(
                              patient: patient,
                              onViewDetails: () {
                                // TODO: navigate to patient details
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
