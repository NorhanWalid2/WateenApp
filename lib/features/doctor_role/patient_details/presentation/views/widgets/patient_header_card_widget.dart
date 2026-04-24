import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/patient_details/data/models/patient_details_model.dart';

class PatientHeaderCardWidget extends StatelessWidget {
  final PatientDetailsModel patient;

  const PatientHeaderCardWidget({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                patient.initial,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${patient.age} years • ${patient.gender}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${patient.patientId}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}