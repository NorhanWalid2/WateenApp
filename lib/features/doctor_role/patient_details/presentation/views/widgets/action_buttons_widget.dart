import 'package:flutter/material.dart';

class PatientActionButtonsWidget extends StatelessWidget {
  final VoidCallback onMessage;
  final VoidCallback onPrescription;
  final VoidCallback onChecklist;

  const PatientActionButtonsWidget({
    super.key,
    required this.onMessage,
    required this.onPrescription,
    required this.onChecklist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Row 1: Message only (full width since no video call) ──
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onMessage,
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              'Message',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ── Row 2: Prescription + Checklist ──
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPrescription,
                icon: Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                label: Text(
                  'Prescription',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onChecklist,
                icon: Icon(
                  Icons.checklist_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                label: Text(
                  'Checklist',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}