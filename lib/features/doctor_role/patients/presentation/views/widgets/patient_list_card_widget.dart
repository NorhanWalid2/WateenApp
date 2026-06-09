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
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          border: Border(
            bottom: BorderSide(color: colorScheme.surface, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  patient.initial,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: primaryRed,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.inverseSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Row(
                  //   children: [
                  //     if (patient.gender.isNotEmpty) ...[
                  //       Icon(
                  //         patient.gender.toLowerCase() == 'female'
                  //             ? Icons.female_rounded
                  //             : Icons.male_rounded,
                  //         size: 14,
                  //         color: colorScheme.outlineVariant,
                  //       ),
                  //       const SizedBox(width: 4),
                  //       Text(
                  //         patient.gender,
                  //         style: TextStyle(
                  //             fontSize: 12, color: colorScheme.outlineVariant),
                  //       ),
                  //       const SizedBox(width: 10),
                  //     ],
                  //     if (patient.phoneNumber.isNotEmpty)
                  //       Text(
                  //         patient.phoneNumber,
                  //         style: TextStyle(
                  //             fontSize: 12, color: colorScheme.outlineVariant),
                  //       ),
                  //   ],
                  // ),
                  const SizedBox(height: 3),
                  // Text(
                  //   patient.email,
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: colorScheme.outlineVariant,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: colorScheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}