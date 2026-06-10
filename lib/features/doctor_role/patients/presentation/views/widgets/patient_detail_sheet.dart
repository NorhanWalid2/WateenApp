// lib/features/doctor_role/patients/presentation/views/patient_detail_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/cubit/doctor_patient_cubit.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/cubit/doctor_patient_state.dart';
 
class PatientDetailSheet extends StatelessWidget {
  final String patientId;
  final String? appointmentId;

  const PatientDetailSheet({
    super.key,
    required this.patientId,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientDetailCubit()..fetchPatient(patientId),
      child: _Body(patientId: patientId, appointmentId: appointmentId),
    );
  }
}

class _Body extends StatefulWidget {
  final String patientId;
  final String? appointmentId;
  const _Body({required this.patientId, required this.appointmentId});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _completing = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BlocBuilder<PatientDetailCubit, PatientDetailState>(
          builder: (context, state) {
            if (state is PatientDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PatientDetailError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: colorScheme.error, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message),
                    TextButton(
                      onPressed: () => context
                          .read<PatientDetailCubit>()
                          .fetchPatient(widget.patientId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is! PatientDetailLoaded) return const SizedBox();

            final patient = state.patient;

            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Patient header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          patient.initial,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: primaryRed,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.name,
                            style: GoogleFonts.archivo(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.inverseSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${patient.gender}${patient.age > 0 ? " · ${patient.age} years" : ""}',
                            style: TextStyle(
                                fontSize: 13, color: colorScheme.outlineVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Contact info
                _InfoCard(title: 'Contact', children: [
                  _InfoRow(icon: Icons.email_outlined, label: 'Email', value: patient.email),
                  _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: patient.phoneNumber),
                  if (patient.address != null && patient.address!.isNotEmpty)
                    _InfoRow(icon: Icons.location_on_outlined, label: 'Address', value: patient.address!),
                ]),

                const SizedBox(height: 14),

                // Vitals
                if (patient.systolicPressure != null || patient.heartRate != null)
                  _InfoCard(title: 'Vitals', children: [
                    if (patient.systolicPressure != null)
                      _VitalRow(
                        icon: Icons.favorite_border_rounded,
                        label: 'Blood Pressure',
                        value: '${patient.systolicPressure}/${patient.diastolicPressure} mmHg',
                        color: (patient.systolicPressure ?? 0) > 140 ? Colors.red : Colors.green,
                      ),
                    if (patient.heartRate != null)
                      _VitalRow(
                        icon: Icons.monitor_heart_outlined,
                        label: 'Heart Rate',
                        value: '${patient.heartRate} bpm',
                        color: (patient.heartRate ?? 0) > 100 ? Colors.orange : Colors.green,
                      ),
                    if (patient.sugar != null)
                      _VitalRow(
                        icon: Icons.water_drop_outlined,
                        label: 'Blood Sugar',
                        value: '${patient.sugar} mg/dL',
                        color: (patient.sugar ?? 0) > 140 ? Colors.orange : Colors.green,
                      ),
                  ]),

                const SizedBox(height: 24),

                // ── 3 Action buttons ──────────────────────────────
                // Complete (only when from appointments)
                if (widget.appointmentId != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _completing
                          ? null
                          : () async {
                              setState(() => _completing = true);
                              final cubit = context.read<PatientDetailCubit>();
                              final success = await cubit
                                  .completeAppointment(widget.appointmentId!);
                              if (context.mounted) {
                                setState(() => _completing = false);
                                Navigator.pop(context, success);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(success
                                      ? 'Appointment completed!'
                                      : 'Failed to complete appointment'),
                                  backgroundColor:
                                      success ? Colors.green : Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            },
                      icon: _completing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle_outline_rounded,
                              size: 18, color: Colors.white),
                      label: Text(
                        _completing ? 'Completing...' : 'Mark as Complete',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor:
                            Colors.green.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Chat + Prescription + Checklist row
                Row(
                  children: [
                    // Chat
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'Chat',
                        color: primaryRed,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/doctorChat', extra: {
                            'patientName': patient.name,
                            'patientId': widget.patientId,
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Prescription
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.medication_outlined,
                        label: 'Prescriptions',
                        color: const Color(0xFF7C3AED),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/prescriptions', extra: patient);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Checklist
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.checklist_rounded,
                        label: 'Checklist',
                        color: const Color(0xFF0891B2),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/checklist', extra: patient);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.outlineVariant)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: colorScheme.outlineVariant),
          const SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(fontSize: 13, color: colorScheme.outlineVariant)),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.inverseSurface)),
          ),
        ],
      ),
    );
  }
}

class _VitalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _VitalRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 13, color: colorScheme.outlineVariant))),
          Text(value,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}