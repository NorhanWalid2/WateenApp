import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/appointments/data/models/nurse_request_model.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/nurse_request_detail_row_widget.dart';

class NurseRequestCardWidget extends StatelessWidget {
  final NurseRequestModel request;

  const NurseRequestCardWidget({super.key, required this.request});

  String _formatTime(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $h:$m $ampm';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final statusLabel = switch (request.status) {
      NurseRequestStatus.approved => 'Approved',
      NurseRequestStatus.rejected => 'Rejected',
      NurseRequestStatus.pending  => 'Pending',
    };

    final statusColor = switch (request.status) {
      NurseRequestStatus.approved => const Color(0xFF16A34A),
      NurseRequestStatus.rejected => colorScheme.error,
      NurseRequestStatus.pending  => const Color(0xFFF59E0B),
    };

    final statusIcon = switch (request.status) {
      NurseRequestStatus.approved => Icons.check_circle_rounded,
      NurseRequestStatus.rejected => Icons.cancel_rounded,
      NurseRequestStatus.pending  => Icons.access_time_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: colorScheme.secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.nurseName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Nurse',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // ── Status badge ──────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(height: 1, color: colorScheme.outline.withOpacity(0.2)),
          const SizedBox(height: 14),

          // ── Service ───────────────────────────────────────────
          NurseRequestDetailRowWidget(
            icon: Icons.medical_information_outlined,
            label: 'Service',
            value: request.serviceDescription,
          ),
          const SizedBox(height: 8),

          // ── Address ───────────────────────────────────────────
          NurseRequestDetailRowWidget(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: request.address,
          ),
          const SizedBox(height: 8),

          // ── Time ─────────────────────────────────────────────
          NurseRequestDetailRowWidget(
            icon: Icons.access_time_rounded,
            label: 'Requested',
            value: _formatTime(request.requestedTime),
          ),
        ],
      ),
    );
  }
}