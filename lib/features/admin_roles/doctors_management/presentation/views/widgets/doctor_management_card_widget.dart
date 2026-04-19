import 'package:flutter/material.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/data/models/doctor_management_model.dart';

class DoctorManagementCardWidget extends StatelessWidget {
  final DoctorManagementModel doctor;
  final VoidCallback onView;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const DoctorManagementCardWidget({
    super.key,
    required this.doctor,
    required this.onView,
    this.onApprove,
    this.onReject,
  });

  Color _statusColor(BuildContext context) {
    switch (doctor.status) {
      case DoctorStatus.pending:
        return const Color(0xFFF59E0B);
      case DoctorStatus.approved:
        return const Color(0xFF16A34A);
      case DoctorStatus.rejected:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  Color _statusBgColor() {
    switch (doctor.status) {
      case DoctorStatus.pending:
        return const Color(0xFFFFFBEB);
      case DoctorStatus.approved:
        return const Color(0xFFECFDF5);
      case DoctorStatus.rejected:
        return const Color(0xFFFEF2F2);
    }
  }

  String _statusText() {
    switch (doctor.status) {
      case DoctorStatus.pending:
        return 'Pending';
      case DoctorStatus.approved:
        return 'Approved';
      case DoctorStatus.rejected:
        return 'Rejected';
    }
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
          // ── Top row: Avatar + Info + Status ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    doctor.initials,
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
                      doctor.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.rating} (${doctor.patientCount} patients)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusBgColor(),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _statusColor(context).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _statusText(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(context),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Details ──
          _DetailRow(
            icon: Icons.location_on_rounded,
            text: doctor.location,
            context: context,
          ),
          const SizedBox(height: 4),
          _DetailRow(
            icon: Icons.badge_rounded,
            text: 'License: ${doctor.licenseNumber}',
            context: context,
          ),
          const SizedBox(height: 4),
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            text: 'Applied: ${doctor.appliedDate}',
            context: context,
          ),

          const SizedBox(height: 14),

          // ── Buttons ──
          Row(
            children: [
              // View button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onView,
                  icon: Icon(
                    Icons.visibility_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  label: Text(
                    'View',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // Approve + Reject (only for pending)
              if (doctor.status == DoctorStatus.pending) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF16A34A).withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onReject,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final BuildContext context;

  const _DetailRow({
    required this.icon,
    required this.text,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}
