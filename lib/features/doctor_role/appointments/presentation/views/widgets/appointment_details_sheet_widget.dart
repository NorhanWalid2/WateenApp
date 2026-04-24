import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/appointment_model.dart';

class AppointmentDetailsSheetWidget extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const AppointmentDetailsSheetWidget({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Handle + Title + Close ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Patient header card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.patientAge} years old',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to patient details
                  },
                  child: Text(
                    'View medical history →',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Details ──
          _DetailRow(
            label: 'Date & Time',
            value: '${appointment.date} at ${appointment.time}',
          ),
          const SizedBox(height: 14),
          _DetailRow(
            label: 'Type',
            value: appointment.type == AppointmentType.inPerson
                ? 'In-person'
                : 'Video Call',
          ),
          const SizedBox(height: 14),
          _DetailRow(
            label: 'Reason for Visit',
            value: appointment.reason,
          ),

          const SizedBox(height: 24),

          // ── Message Patient button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(
                  '/doctorChat',
                  extra: {
                    'patientName': appointment.patientName,
                    'patientId': appointment.patientId,
                  },
                );
              },
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Message Patient',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outlineVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      ],
    );
  }
}