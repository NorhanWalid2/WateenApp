import 'package:flutter/material.dart';
import 'package:wateen_app/features/admin_roles/dashboard/data/models/dashboard_model.dart';

class RecentActivityItemWidget extends StatelessWidget {
  final RecentActivityModel activity;

  const RecentActivityItemWidget({super.key, required this.activity});

  Color _dotColor(BuildContext context) {
    switch (activity.type) {
      case ActivityType.approved:
        return const Color(0xFF16A34A);
      case ActivityType.registered:
        return const Color(0xFF3B82F6);
      case ActivityType.completed:
        return const Color(0xFF16A34A);
      case ActivityType.rejected:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _dotColor(context),
                shape: BoxShape.circle,
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
                  activity.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),

          // Time
          Text(
            activity.timeAgo,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}
