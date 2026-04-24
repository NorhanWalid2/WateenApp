import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/dashboard/data/models/doctor_dashboard_model.dart';


class AlertCardWidget extends StatelessWidget {
  final PatientAlertModel alert;
  final VoidCallback onViewDetails;

  const AlertCardWidget({
    super.key,
    required this.alert,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = alert.type == AlertType.critical;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCritical
            ? const Color(0xFFFEF2F2)
            : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCritical
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
              : const Color(0xFFFCD34D).withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name + Icon ──
          Row(
            children: [
              Icon(
                isCritical
                    ? Icons.error_outline_rounded
                    : Icons.warning_amber_rounded,
                size: 18,
                color: isCritical
                    ? Theme.of(context).colorScheme.secondary
                    : const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.patientName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── Message ──
          Text(
            alert.message,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),

          const SizedBox(height: 8),

          // ── View Details ──
          GestureDetector(
            onTap: onViewDetails,
            child: Text(
              'View Details →',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isCritical
                    ? Theme.of(context).colorScheme.secondary
                    : const Color(0xFFF59E0B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}