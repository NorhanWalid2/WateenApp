import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_colors.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/detail_row_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/patient_info_row_widget.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/chat_view.dart';

class AppointmentDetailsView extends StatelessWidget {
  const AppointmentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // بيانات الدكتور — هتيجي من الـ model لما تربطي الـ backend
    final doctorConversation = ConversationModel(
      doctorName: 'Dr. Sarah Ahmed',
      specialty: 'Cardiologist',
      lastMessage: '',
      time: '',
      unreadCount: 0,
      initials: 'SA',
      color: colorScheme.secondary,
      isOnline: true, otherUserId: '',
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.appointmentDetails),
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
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'SA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Sarah Ahmed',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Cardiologist',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
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
            Text(
              l10n.scheduledAppointment,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  DetailRowWidget(
                    icon: Icons.calendar_today_rounded,
                    iconColor: colorScheme.secondary,
                    label: l10n.date,
                    value: 'December 24, 2024',
                  ),
                  const SizedBox(height: 12),
                  DetailRowWidget(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.orange,
                    label: l10n.time,
                    value: '10:00 AM - 10:30 AM',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Patient Info ────────────────────
            Text(
              l10n.patientInformation,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  PatientInfoRowWidget(
                    label: l10n.fullName,
                    value: 'Ahmed Al-Mansouri',
                  ),
                  const SizedBox(height: 10),
                  PatientInfoRowWidget(label: l10n.gender, value: l10n.male),
                  const SizedBox(height: 10),
                  PatientInfoRowWidget(
                    label: l10n.age,
                    value: '32 ${l10n.years}',
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.problem,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
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
            Text(
              l10n.yourPackage,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
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
                      color: colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: colorScheme.secondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.messagingConsultation,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${l10n.duration}: 30 ${l10n.minutes}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'AED\n150',
                    textAlign: TextAlign.right,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // ── Start Message Button ────────────
            CustomButton(
              color: AppColorsLight.secondary,
              colorText: AppColorsLight.background,
              title: l10n.startMessage,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChatView(conversation: doctorConversation),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
