import 'package:flutter/material.dart';

class ChecklistHeaderWidget extends StatelessWidget {
  final String patientName;
  final int completedCount;
  final int totalCount;

  const ChecklistHeaderWidget({
    super.key,
    required this.patientName,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Care Plan & Tasks',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Progress row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              Text(
                '$completedCount/$totalCount',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── Progress bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: totalCount > 0 ? completedCount / totalCount : 0,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}