import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';

class AppointmentCardWidget extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;
  final VoidCallback onAction;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.onAction,
    required this.onReschedule,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor Row ──────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.secondary.withOpacity(0.15),
                  child: Text(
                    appointment.avatarInitials,
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment.specialty,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Info Rows ───────────────────────
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.date,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.time,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  _typeIcon(appointment.type),
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.typeLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Action Button ───────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(
                  _actionIcon(appointment.type),
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  _actionLabel(appointment.type),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Reschedule / Cancel ─────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: onReschedule,
                  child: Text(
                    'Reschedule',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onCancel,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.video:
        return Icons.videocam_rounded;
      case AppointmentType.inPerson:
        return Icons.location_on_rounded;
      case AppointmentType.message:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  IconData _actionIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.video:
        return Icons.video_call_rounded;
      case AppointmentType.inPerson:
        return Icons.phone_rounded;
      case AppointmentType.message:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  String _actionLabel(AppointmentType type) {
    switch (type) {
      case AppointmentType.video:
        return 'Join Call';
      case AppointmentType.inPerson:
        return 'Call Doctor';
      case AppointmentType.message:
        return 'Message Doctor';
    }
  }
}
