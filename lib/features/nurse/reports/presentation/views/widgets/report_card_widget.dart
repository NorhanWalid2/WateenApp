import 'package:flutter/material.dart';
import 'package:wateen_app/features/nurse/reports/data/models/report_model.dart';

class ReportCardWidget extends StatelessWidget {
  final ReportModel report;
  final VoidCallback onViewDetails;

  const ReportCardWidget({
    super.key,
    required this.report,
    required this.onViewDetails,
  });

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
          // ── Name + Status ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.patientName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF16A34A).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  report.status,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Date ──
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(width: 6),
              Text(
                report.dateTime,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── Location ──
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(width: 6),
              Text(
                report.location,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(color: Theme.of(context).colorScheme.surface, thickness: 1),

          const SizedBox(height: 8),

          // ── Vitals + View Details ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Vitals recorded indicator
              Row(
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    size: 16,
                    color:
                        report.vitalsRecorded
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.outlineVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    report.vitalsRecorded ? 'Vitals Recorded' : 'No Vitals',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          report.vitalsRecorded
                              ? Theme.of(context).colorScheme.inverseSurface
                              : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),

              // View details
              GestureDetector(
                onTap: onViewDetails,
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
