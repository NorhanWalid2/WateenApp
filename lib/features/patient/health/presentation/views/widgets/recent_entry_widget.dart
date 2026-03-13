import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/health/data/models/vital_entry_model.dart';

class RecentEntryWidget extends StatelessWidget {
  final VitalEntryModel entry;
  final String label;
  final Color color;
  final IconData icon;

  const RecentEntryWidget({
    super.key,
    required this.entry,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final value = entry.secondValue != null
        ? '${entry.value.toInt()}/${entry.secondValue!.toInt()} ${entry.unit}'
        : '${entry.value} ${entry.unit}';

    final timeStr =
        '${entry.time.day}/${entry.time.month}/${entry.time.year}  '
        '${entry.time.hour}:${entry.time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant)),
                Text(
                  value,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}