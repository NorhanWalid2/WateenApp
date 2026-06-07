// lib/features/doctor_role/patients/presentation/views/patients_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/cubit/doctor_patient_cubit.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/cubit/doctor_patient_state.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/views/widgets/patient_detail_sheet.dart';
import 'widgets/patient_list_card_widget.dart';
 
class DoctorPatientsView extends StatefulWidget {
  const DoctorPatientsView({super.key});

  @override
  State<DoctorPatientsView> createState() => _DoctorPatientsViewState();
}

class _DoctorPatientsViewState extends State<DoctorPatientsView> {
  final TextEditingController _searchController = TextEditingController();
  late final DoctorPatientsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DoctorPatientsCubit()..fetchPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  List<PatientModel> _filtered(List<PatientModel> all) {
    if (_searchController.text.isEmpty) return all;
    final q = _searchController.text.toLowerCase();
    return all.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.email.toLowerCase().contains(q) ||
        p.phoneNumber.contains(q)).toList();
  }

  void _showPatientDetail(String patientId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PatientDetailSheet(
        patientId: patientId,
        appointmentId: null, // no appointment context from patients list
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Patients',
                          style: GoogleFonts.archivo(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: _cubit.fetchPatients,
                          child: Icon(Icons.refresh_rounded,
                              color: Theme.of(context).colorScheme.inverseSurface),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: Theme.of(context).colorScheme.outlineVariant,
                              size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.inverseSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search patients...',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.outlineVariant,
                                    fontSize: 14),
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

              // ── Body ─────────────────────────────────────────────
              Expanded(
                child: BlocBuilder<DoctorPatientsCubit, DoctorPatientsState>(
                  builder: (context, state) {
                    if (state is DoctorPatientsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is DoctorPatientsError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.error),
                            const SizedBox(height: 12),
                            Text(state.message),
                            TextButton(
                              onPressed: _cubit.fetchPatients,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final patients = state is DoctorPatientsLoaded
                        ? _filtered(state.patients)
                        : <PatientModel>[];

                    if (patients.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.outlineVariant),
                            const SizedBox(height: 12),
                            Text('No patients found',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.outlineVariant)),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _cubit.fetchPatients,
                      child: ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return PatientListCardWidget(
                            patient: patient,
                            onTap: () => _showPatientDetail(patient.id),
                          );
                        },
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