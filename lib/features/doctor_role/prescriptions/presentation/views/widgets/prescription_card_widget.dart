import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/data/prescription_model.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback? onEdit;

  const PrescriptionCardWidget({
    super.key,
    required this.prescription,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = prescription.status == PrescriptionStatus.active;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
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

          // ── Name + Edit ──
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prescription.medicationName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
              if (isActive && onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Dosage ──
          Text(
            prescription.dosage,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          const SizedBox(height: 10),

          // ── Details ──
          _DetailRow(
            icon: Icons.access_time_rounded,
            text: 'Frequency: ${prescription.frequency}',
          ),
          const SizedBox(height: 4),
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            text: 'Duration: ${prescription.duration}',
          ),
          const SizedBox(height: 4),
          _DetailRow(
            icon: Icons.info_outline_rounded,
            text: 'Instructions: ${prescription.instructions}',
          ),

          const SizedBox(height: 10),

          // ── Dates ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Started: ${prescription.startDate}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              if (!isActive && prescription.endDate != null)
                Text(
                  'Ended: ${prescription.endDate}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
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

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
      ],
    );
  }
}