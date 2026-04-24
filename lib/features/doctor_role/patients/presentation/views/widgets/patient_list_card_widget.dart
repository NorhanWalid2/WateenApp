import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';

class PatientListCardWidget extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onTap;

  const PatientListCardWidget({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // ── Avatar ──
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEF9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  patient.initial,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${patient.age} years • ${patient.condition}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Last visit: ${patient.lastVisit}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),

            // ── Arrow ──
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}