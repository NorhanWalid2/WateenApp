import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/active_visit_model.dart';
import 'widgets/patient_info_card_widget.dart';
import 'widgets/description_field_widget.dart';
import 'widgets/vitals_form_widget.dart';

class ActiveVisitView extends StatefulWidget {
  const ActiveVisitView({super.key});

  @override
  State<ActiveVisitView> createState() => _ActiveVisitViewState();
}

class _ActiveVisitViewState extends State<ActiveVisitView> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _oxygenLevelController = TextEditingController();

  // TODO: replace with real data from API
  final ActiveVisitModel _visit = ActiveVisitModel(
    patientName: 'Ahmed Al-Mansouri',
    address: 'Villa 123, Al Barsha, Dubai',
    phoneNumber: '+971 50 123 4567',
  );

  bool get _isFormValid => _descriptionController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _descriptionController.dispose();
    _bloodPressureController.dispose();
    _heartRateController.dispose();
    _temperatureController.dispose();
    _oxygenLevelController.dispose();
    super.dispose();
  }

  void _onCallPatient() {
    // TODO: launch phone call
  }

  void _onNavigate() {
    // TODO: launch maps navigation
  }

  void _onCompleteVisit() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter visit description'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }

    // TODO: connect complete visit API
    final vitals = VitalsModel(
      bloodPressure: _bloodPressureController.text.trim(),
      heartRate: _heartRateController.text.trim(),
      temperature: _temperatureController.text.trim(),
      oxygenLevel: _oxygenLevelController.text.trim(),
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Complete Visit'),
            content: const Text(
              'Are you sure you want to mark this visit as complete?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: navigate to reports or home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: const Text(
                  'Complete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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
                    'Active Visit',
                    style: GoogleFonts.archivo(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  const Spacer(),
                  // Active indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'In Progress',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
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
                    // Patient info card
                    PatientInfoCardWidget(
                      visit: _visit,
                      onCall: _onCallPatient,
                      onNavigate: _onNavigate,
                    ),

                    const SizedBox(height: 16),

                    // Description field
                    DescriptionFieldWidget(controller: _descriptionController),

                    const SizedBox(height: 16),

                    // Vitals form
                    VitalsFormWidget(
                      bloodPressureController: _bloodPressureController,
                      heartRateController: _heartRateController,
                      temperatureController: _temperatureController,
                      oxygenLevelController: _oxygenLevelController,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Complete Visit Button ──
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _onCompleteVisit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Complete Visit',
                    style: GoogleFonts.archivo(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
