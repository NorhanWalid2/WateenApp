import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/nurse_model.dart';
import 'widgets/nurse_search_bar_widget.dart';
import 'widgets/nurse_filter_chip_widget.dart';
import 'widgets/nurse_list_widget.dart';

class RequestNurseView extends StatefulWidget {
  const RequestNurseView({super.key});

  @override
  State<RequestNurseView> createState() => _RequestNurseViewState();
}

class _RequestNurseViewState extends State<RequestNurseView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String? _selectedNurseId;

  // TODO: replace with real API data
  final List<NurseModel> _allNurses = [
    NurseModel(
      id: '1',
      name: 'Fatima Al-Rashid',
      specialty: 'General Care Nurse',
      rating: 4.9,
      reviewCount: 156,
      yearsExperience: 12,
      hourlyRate: 80,
      isAvailable: true,
      initials: 'FA',
      skills: [
        'Vital Signs Monitoring',
        'Medication Administration',
        'Wound Care',
      ],
      completedJobs: 248,
    ),
    NurseModel(
      id: '2',
      name: 'Sarah Abdullah',
      specialty: 'Pediatric Nurse',
      rating: 4.8,
      reviewCount: 134,
      yearsExperience: 10,
      hourlyRate: 90,
      isAvailable: true,
      initials: 'SA',
      skills: ['Child Care', 'Vaccination', 'Pediatric Assessment'],
      completedJobs: 189,
    ),
    NurseModel(
      id: '3',
      name: 'Mariam Hassan',
      specialty: 'ICU Nurse',
      rating: 4.9,
      reviewCount: 198,
      yearsExperience: 15,
      hourlyRate: 110,
      isAvailable: true,
      initials: 'MH',
      skills: ['Critical Care', 'Post-Surgery Care', 'Ventilator Management'],
      completedJobs: 312,
    ),
  ];

  final List<String> _filters = [
    'All',
    'General Care',
    'Pediatric',
    'ICU',
    'Post-Surgery',
  ];

  List<NurseModel> get _filteredNurses {
    return _allNurses.where((nurse) {
      final matchesSearch =
          _searchController.text.isEmpty ||
          nurse.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          nurse.specialty.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      final matchesFilter =
          _selectedFilter == 'All' ||
          nurse.specialty.toLowerCase().contains(_selectedFilter.toLowerCase());
      return matchesSearch && matchesFilter;
    }).toList();
  }

  NurseModel? get _selectedNurse {
    try {
      return _allNurses.firstWhere((n) => n.id == _selectedNurseId);
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
            // Header
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
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
                        'Request Nurse',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  NurseSearchBarWidget(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  NurseFilterChipWidget(
                    filters: _filters,
                    selected: _selectedFilter,
                    onSelected: (val) => setState(() => _selectedFilter = val),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),

            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Nurses',
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
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredNurses.length} nurses',
                      style: const TextStyle(
                        color: Color(0xFF7C3AED),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Nurses list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: NurseListWidget(
                  nurses: _filteredNurses,
                  selectedNurseId: _selectedNurseId,
                  onNurseSelected:
                      (nurse) => setState(() => _selectedNurseId = nurse.id),
                ),
              ),
            ),

            // Continue button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      _selectedNurse == null
                          ? null
                          : () => context.push(
                            '/nurseRequestDetails',
                            extra: _selectedNurse,
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
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
