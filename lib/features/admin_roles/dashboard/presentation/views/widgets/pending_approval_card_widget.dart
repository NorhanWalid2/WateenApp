import 'package:flutter/material.dart';
import 'package:wateen_app/features/admin_roles/dashboard/data/models/dashboard_model.dart';

class PendingApprovalCardWidget extends StatelessWidget {
  final PendingApprovalModel approval;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingApprovalCardWidget({
    super.key,
    required this.approval,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                approval.name.split(' ').map((e) => e[0]).take(2).join(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary,
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
                  approval.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${approval.role} · ${approval.specialty}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  approval.timeAgo,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),

          // Approve + Reject buttons
          Row(
            children: [
              GestureDetector(
                onTap: onApprove,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      // Fix #4: withValues instead of withOpacity
                      color: const Color(0xFF16A34A).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF16A34A),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onReject,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      // Fix #4: withValues instead of withOpacity
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 18,
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