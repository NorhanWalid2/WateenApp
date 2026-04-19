import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/doctor_management_model.dart';
import 'widgets/doctor_management_card_widget.dart';

class DoctorsManagementView extends StatefulWidget {
  const DoctorsManagementView({super.key});

  @override
  State<DoctorsManagementView> createState() => _DoctorsManagementViewState();
}

class _DoctorsManagementViewState extends State<DoctorsManagementView> {
  final TextEditingController _searchController = TextEditingController();
  DoctorStatus? _selectedStatus;

  // TODO: replace with real API data
  final List<DoctorManagementModel> _allDoctors = [
    DoctorManagementModel(
      id: '1',
      name: 'Dr. Sarah Ahmed',
      specialty: 'Cardiologist',
      rating: 4.8,
      patientCount: 156,
      location: 'Dubai Healthcare City',
      licenseNumber: 'DHA-12345',
      appliedDate: '2024-01-20',
      status: DoctorStatus.pending,
    ),
    DoctorManagementModel(
      id: '2',
      name: 'Dr. Mohammed Ali',
      specialty: 'Pediatrician',
      rating: 4.9,
      patientCount: 203,
      location: 'Abu Dhabi',
      licenseNumber: 'DHA-23456',
      appliedDate: '2024-01-15',
      status: DoctorStatus.approved,
    ),
    DoctorManagementModel(
      id: '3',
      name: 'Dr. Fatima Hassan',
      specialty: 'General Practitioner',
      rating: 4.7,
      patientCount: 89,
      location: 'Sharjah',
      licenseNumber: 'DHA-34567',
      appliedDate: '2024-01-22',
      status: DoctorStatus.pending,
    ),
    DoctorManagementModel(
      id: '4',
      name: 'Dr. Ahmed Khalid',
      specialty: 'Dermatologist',
      rating: 4.6,
      patientCount: 120,
      location: 'Dubai Marina',
      licenseNumber: 'DHA-45678',
      appliedDate: '2024-01-10',
      status: DoctorStatus.rejected,
    ),
  ];

  List<DoctorManagementModel> get _filteredDoctors {
    return _allDoctors.where((doctor) {
      final matchesSearch =
          _searchController.text.isEmpty ||
          doctor.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          doctor.specialty.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      final matchesStatus =
          _selectedStatus == null || doctor.status == _selectedStatus;
      return matchesSearch && matchesStatus;
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
                      'Doctor Management',
                      style: GoogleFonts.archivo(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review and manage doctor applications',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
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
                                hintText: 'Search by name or specialty...',
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

                    const SizedBox(height: 14),

                    // ── Filter chips ──
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            isActive: _selectedStatus == null,
                            onTap: () => setState(() => _selectedStatus = null),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Pending',
                            isActive: _selectedStatus == DoctorStatus.pending,
                            onTap:
                                () => setState(
                                  () => _selectedStatus = DoctorStatus.pending,
                                ),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Approved',
                            isActive: _selectedStatus == DoctorStatus.approved,
                            onTap:
                                () => setState(
                                  () => _selectedStatus = DoctorStatus.approved,
                                ),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Rejected',
                            isActive: _selectedStatus == DoctorStatus.rejected,
                            onTap:
                                () => setState(
                                  () => _selectedStatus = DoctorStatus.rejected,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Doctors List ──
                    _filteredDoctors.isEmpty
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
                                  'No doctors found',
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
                          itemCount: _filteredDoctors.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final doctor = _filteredDoctors[index];
                            return DoctorManagementCardWidget(
                              doctor: doctor,
                              onView: () {
                                // TODO: navigate to doctor details
                              },
                              onApprove: () {
                                // TODO: connect approve API
                                setState(() {
                                  final i = _allDoctors.indexWhere(
                                    (d) => d.id == doctor.id,
                                  );
                                  _allDoctors[i] = DoctorManagementModel(
                                    id: doctor.id,
                                    name: doctor.name,
                                    specialty: doctor.specialty,
                                    rating: doctor.rating,
                                    patientCount: doctor.patientCount,
                                    location: doctor.location,
                                    licenseNumber: doctor.licenseNumber,
                                    appliedDate: doctor.appliedDate,
                                    status: DoctorStatus.approved,
                                  );
                                });
                              },
                              onReject: () {
                                // TODO: connect reject API
                                setState(() {
                                  final i = _allDoctors.indexWhere(
                                    (d) => d.id == doctor.id,
                                  );
                                  _allDoctors[i] = DoctorManagementModel(
                                    id: doctor.id,
                                    name: doctor.name,
                                    specialty: doctor.specialty,
                                    rating: doctor.rating,
                                    patientCount: doctor.patientCount,
                                    location: doctor.location,
                                    licenseNumber: doctor.licenseNumber,
                                    appliedDate: doctor.appliedDate,
                                    status: DoctorStatus.rejected,
                                  );
                                });
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color:
                isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:
                isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
