import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';


class AppointmentCardWidget extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final VoidCallback onTap;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVideoCall = appointment.type == AppointmentType.videoCall;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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

            // ── Name + Type badge ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment.patientName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                // Type badge — display only, not a button
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVideoCall
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isVideoCall ? 'Video Call' : 'In-person',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isVideoCall
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // ── Age ──
            Text(
              '${appointment.patientAge} years old',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),

            const SizedBox(height: 10),

            // ── Date ──
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ── Time ──
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ── Reason ──
            Row(
              children: [
                Icon(
                  Icons.notes_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.reason,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}