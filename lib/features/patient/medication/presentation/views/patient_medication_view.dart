import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/data/prescription_model.dart';
import 'package:wateen_app/features/patient/medication/data/models/patient_medication_model.dart';
import 'package:wateen_app/features/patient/medication/presentation/cubit/medication_cubit.dart';
import 'package:wateen_app/features/patient/medication/presentation/cubit/medication_state.dart';

class PatientMedicationsView extends StatefulWidget {
  const PatientMedicationsView({super.key});

  @override
  State<PatientMedicationsView> createState() => _PatientMedicationsViewState();
}

class _PatientMedicationsViewState extends State<PatientMedicationsView> {
  bool _isActiveTab = true;
  late final PatientMedicationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PatientMedicationCubit()..fetchMedications(activeOnly: true);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _switchTab(bool active) {
    setState(() => _isActiveTab = active);
    _cubit.fetchMedications(activeOnly: active);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────
              Container(
                color: colorScheme.primary,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded,
                                size: 16, color: colorScheme.inverseSurface),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'My Medications',
                          style: GoogleFonts.archivo(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () =>
                              _cubit.fetchMedications(activeOnly: _isActiveTab),
                          child: Icon(Icons.refresh_rounded,
                              color: colorScheme.inverseSurface),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _TabBtn(
                            label: 'Active',
                            isActive: _isActiveTab,
                            onTap: () => _switchTab(true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TabBtn(
                            label: 'Past',
                            isActive: !_isActiveTab,
                            onTap: () => _switchTab(false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Body ─────────────────────────────────────────────
              Expanded(
                child: BlocBuilder<PatientMedicationCubit,
                    PatientMedicationState>(
                  builder: (context, state) {
                    if (state is PatientMedicationLoading) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: primaryRed, strokeWidth: 2));
                    }
                    if (state is PatientMedicationError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline_rounded,
                                size: 48, color: colorScheme.error),
                            const SizedBox(height: 12),
                            Text(state.message),
                            TextButton(
                              onPressed: () => _cubit.fetchMedications(
                                  activeOnly: _isActiveTab),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final meds = state is PatientMedicationLoaded
                        ? state.medications
                        : <PatientMedicationModel>[];

                    if (meds.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medication_outlined,
                                size: 56, color: colorScheme.outlineVariant),
                            const SizedBox(height: 12),
                            Text(
                              _isActiveTab
                                  ? 'No active medications'
                                  : 'No past medications',
                              style: TextStyle(
                                  color: colorScheme.outlineVariant),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: primaryRed,
                      onRefresh: () =>
                          _cubit.fetchMedications(activeOnly: _isActiveTab),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: meds.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _MedicationCard(med: meds[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Medication Card ───────────────────────────────────────────────────────────
class _MedicationCard extends StatelessWidget {
  final PatientMedicationModel med;
  const _MedicationCard({required this.med});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.medication_rounded,
                    color: primaryRed, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  med.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.inverseSurface,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: med.isActive
                      ? Colors.green.withOpacity(0.1)
                      : colorScheme.outlineVariant.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  med.isActive ? 'Active' : 'Past',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: med.isActive
                        ? Colors.green
                        : colorScheme.outlineVariant,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            med.dosage,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryRed),
          ),

          const SizedBox(height: 8),

          _Row(
            icon: Icons.access_time_rounded,
            text: 'Frequency: ${PrescriptionModel.formatFrequency(med.frequency)}',
          ),
          const SizedBox(height: 4),
          _Row(
            icon: Icons.calendar_today_rounded,
            text: 'Duration: ${med.duration}',
          ),
          if (med.instructions.isNotEmpty) ...[
            const SizedBox(height: 4),
            _Row(
              icon: Icons.info_outline_rounded,
              text: 'Instructions: ${med.instructions}',
            ),
          ],

          const SizedBox(height: 8),

          Text(
            'Started: ${med.startDate}',
            style:
                TextStyle(fontSize: 12, color: colorScheme.outlineVariant),
          ),
        ],
      ),
    );
  }
}

// ── Row helper ────────────────────────────────────────────────────────────────
class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.outlineVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.outlineVariant),
          ),
        ),
      ],
    );
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────
class _TabBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabBtn(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFDC2626);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:
              isActive ? primaryRed : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? primaryRed
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}