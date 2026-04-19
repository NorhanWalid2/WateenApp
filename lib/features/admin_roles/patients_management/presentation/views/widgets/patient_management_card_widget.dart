import 'package:flutter/material.dart';
import 'package:wateen_app/features/admin_roles/patients_management/data/models/patient_management_model.dart';

class PatientManagementCardWidget extends StatelessWidget {
  final PatientManagementModel patient;
  final VoidCallback onViewDetails;

  const PatientManagementCardWidget({
    super.key,
    required this.patient,
    required this.onViewDetails,
  });

  Color _avatarColor(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.secondary,
      const Color(0xFF3B82F6),
      const Color(0xFF16A34A),
      const Color(0xFF7C3AED),
      const Color(0xFFF59E0B),
    ];
    return colors[patient.name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _avatarColor(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    patient.initials,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      patient.gender,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Appointments badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${patient.appointmentsCount} appointments',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(color: Theme.of(context).colorScheme.surface, thickness: 1),

          const SizedBox(height: 10),

          // ── Contact details ──
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(width: 6),
              Text(
                patient.email,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(width: 6),
              Text(
                patient.phone,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Last visit: ${patient.lastVisit}',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── View Details button ──
          OutlinedButton.icon(
            onPressed: onViewDetails,
            icon: Icon(
              Icons.visibility_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            label: Text(
              'View Details',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
