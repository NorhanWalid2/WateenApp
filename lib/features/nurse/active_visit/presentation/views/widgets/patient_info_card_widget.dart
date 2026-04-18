import 'package:flutter/material.dart';
import 'package:wateen_app/features/nurse/active_visit/data/models/active_visit_model.dart';


class PatientInfoCardWidget extends StatelessWidget {
  final ActiveVisitModel visit;
  final VoidCallback onCall;
  final VoidCallback onNavigate;

  const PatientInfoCardWidget({
    super.key,
    required this.visit,
    required this.onCall,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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

          // ── Title ──
          Text(
            'Patient Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          const SizedBox(height: 12),

          // ── Patient Name ──
          Text(
            visit.patientName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          const SizedBox(height: 6),

          // ── Address ──
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  visit.address,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Call + Navigate Buttons ──
          Row(
            children: [
              // Call button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall,
                  icon: Icon(
                    Icons.call_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text(
                    'Call Patient',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Navigate button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onNavigate,
                  icon: Icon(
                    Icons.navigation_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text(
                    'Navigate',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.5,
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
      ),
    );
  }
}