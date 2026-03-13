import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/book_appointment_model.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/specialty_filter_widget.dart';
import 'widgets/doctors_list_widget.dart';

class BookAppointmentView extends StatefulWidget {
  const BookAppointmentView({super.key});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';
  String? _selectedDoctorId;

  // ── Dummy data — replace with your API call ──
  final List<BookAppointmentModel> _allDoctors = [
    BookAppointmentModel(
      id: '1',
      name: 'Dr. Sarah Johnson',
      specialty: 'General Physician',
      rating: 4.8,
      reviewCount: 127,
      yearsExperience: 15,
      consultationFee: 150,
      isAvailable: true,
      initials: 'SJ',
    ),
    BookAppointmentModel(
      id: '2',
      name: 'Dr. Ahmed Hassan',
      specialty: 'Cardiologist',
      rating: 4.9,
      reviewCount: 203,
      yearsExperience: 20,
      consultationFee: 250,
      isAvailable: true,
      initials: 'AH',
    ),
    BookAppointmentModel(
      id: '3',
      name: 'Dr. Maria Garcia',
      specialty: 'Dermatologist',
      rating: 4.7,
      reviewCount: 95,
      yearsExperience: 12,
      consultationFee: 200,
      isAvailable: true,
      initials: 'MG',
    ),
    BookAppointmentModel(
      id: '4',
      name: 'Dr. Michael Chen',
      specialty: 'Pediatrician',
      rating: 4.9,
      reviewCount: 156,
      yearsExperience: 18,
      consultationFee: 180,
      isAvailable: false,
      initials: 'MC',
    ),
    BookAppointmentModel(
      id: '5',
      name: 'Dr. Fatima Al-Sayed',
      specialty: 'Gynecologist',
      rating: 4.8,
      reviewCount: 134,
      yearsExperience: 14,
      consultationFee: 220,
      isAvailable: true,
      initials: 'FA',
    ),
  ];

  final List<String> _specialties = [
    'All',
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Gynecologist',
  ];

  // ── Filtered list based on search + specialty ──
  List<BookAppointmentModel> get _filteredDoctors {
    return _allDoctors.where((doctor) {
      final matchesSearch =
          _searchController.text.isEmpty ||
          doctor.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          doctor.specialty.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesSpecialty =
          _selectedSpecialty == 'All' || doctor.specialty == _selectedSpecialty;

      return matchesSearch && matchesSpecialty;
    }).toList();
  }

  BookAppointmentModel? get _selectedDoctor {
    try {
      return _allDoctors.firstWhere((d) => d.id == _selectedDoctorId);
    } catch (_) {
      return null;
    }
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
            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back + Title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Book Appointment',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Search bar
                  SearchBarWidget(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 14),

                  // Specialty filter chips
                  SpecialtyFilterWidget(
                    specialties: _specialties,
                    selected: _selectedSpecialty,
                    onSelected:
                        (val) => setState(() => _selectedSpecialty = val),
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            ),

            // ── Section header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Doctors',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredDoctors.length} doctors',
                      style: const TextStyle(
                        color: Color(0xFF0D9488),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Doctors list ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: DoctorsListWidget(
                  doctors: _filteredDoctors,
                  selectedDoctorId: _selectedDoctorId,
                  onDoctorSelected: (doctor) {
                    setState(() => _selectedDoctorId = doctor.id);
                  },
                ),
              ),
            ),

            // ── Continue button ──
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      _selectedDoctor == null
                          ? null
                          : () {
                            // TODO: navigate to schedule appointment
                            // Navigator.pushNamed(context, '/schedule-appointment',
                            //   arguments: _selectedDoctor);
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    disabledBackgroundColor:
                        Theme.of(context).colorScheme.outlineVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
