import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/patient_model.dart';
import 'widgets/patient_list_card_widget.dart';

class DoctorPatientsView extends StatefulWidget {
  const DoctorPatientsView({super.key});

  @override
  State<DoctorPatientsView> createState() => _DoctorPatientsViewState();
}

class _DoctorPatientsViewState extends State<DoctorPatientsView> {
  final TextEditingController _searchController = TextEditingController();

  // TODO: replace with real API data
  final List<PatientModel> _allPatients = [
    PatientModel(
      id: '1',
      name: 'Ahmed Al-Mansouri',
      age: 54,
      condition: 'Hypertension',
      lastVisit: '2 days ago',
      initial: 'A',
    ),
    PatientModel(
      id: '2',
      name: 'Fatima Hassan',
      age: 38,
      condition: 'Diabetes Type 2',
      lastVisit: '1 week ago',
      initial: 'F',
    ),
    PatientModel(
      id: '3',
      name: 'Mohammed Rashid',
      age: 62,
      condition: 'Heart Disease',
      lastVisit: 'Today',
      initial: 'M',
    ),
    PatientModel(
      id: '4',
      name: 'Layla Ahmed',
      age: 29,
      condition: 'Asthma',
      lastVisit: '3 days ago',
      initial: 'L',
    ),
  ];

  List<PatientModel> get _filteredPatients {
    if (_searchController.text.isEmpty) return _allPatients;
    return _allPatients.where((p) =>
      p.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      ) ||
      p.condition.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      ),
    ).toList();
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Patients',
                    style: GoogleFonts.archivo(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search patients...',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
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
                ],
              ),
            ),

            // ── Patient List ──
            Expanded(
              child: _filteredPatients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No patients found',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];
                        return PatientListCardWidget(
                          patient: patient,
                          onTap: () => context.push(
                            '/patientDetails',
                            extra: patient,
                          ),
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