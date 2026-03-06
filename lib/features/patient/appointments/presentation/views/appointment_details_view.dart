import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/detail_row_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/patient_info_row_widget.dart';

class AppointmentDetailsView extends StatelessWidget {
  const AppointmentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Appointment Details'),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor Card ─────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'DA',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. Sarah Ahmed', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text('Cardiologist', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text(
                            'Dubai Healthcare City',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Scheduled Appointment ───────────
            Text('Scheduled Appointment', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  DetailRowWidget(
                    icon: Icons.calendar_today_rounded,
                    iconColor: colorScheme.secondary,
                    label: 'Date',
                    value: 'December 24, 2024',
                  ),
                  const SizedBox(height: 12),
                  DetailRowWidget(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.orange,
                    label: 'Time',
                    value: '10:00 AM - 10:30 AM',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Patient Info ────────────────────
            Text('Patient Information', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  const PatientInfoRowWidget(label: 'Full Name', value: 'Ahmed Al-Mansouri'),
                  const SizedBox(height: 10),
                  const PatientInfoRowWidget(label: 'Gender', value: 'Male'),
                  const SizedBox(height: 10),
                  const PatientInfoRowWidget(label: 'Age', value: '32 Years'),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Problem', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text(
                        'Experiencing chest pain and shortness of breath during physical activity. Need consultation regarding heart health.',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Your Package ────────────────────
            Text('Your Package', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.chat_bubble_outline_rounded, color: colorScheme.secondary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Messaging Consultation', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        Text('Duration: 30 minutes', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Text(
                    'AED\n150',
                    textAlign: TextAlign.right,
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.secondary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
            label: const Text(
              'Start Message (at 10:00 AM)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}