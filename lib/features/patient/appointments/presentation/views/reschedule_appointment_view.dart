import 'package:flutter/material.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/appointment_type_chip_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/calendar_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/reason_option_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/time_chip_widget.dart';

class RescheduleAppointmentView extends StatefulWidget {
  const RescheduleAppointmentView({super.key});

  @override
  State<RescheduleAppointmentView> createState() =>
      RescheduleAppointmentViewState();
}

class RescheduleAppointmentViewState extends State<RescheduleAppointmentView> {
  int step = 0;
  int? selectedReason;
  DateTime focusedMonth = DateTime(2026, 2);
  DateTime? selectedDate;
  String? selectedTime;
  int selectedType = 0;

  final List<String> times = [
    '09:00 AM', '09:30 AM', '10:00 AM',
    '10:30 AM', '11:00 AM', '11:30 AM',
    '12:00 PM', '12:30 PM', '02:00 PM',
    '02:30 PM', '03:00 PM', '03:30 PM',
    '04:00 PM', '04:30 PM', '05:00 PM',
    '05:30 PM',
  ];

  List<String> buildReasons(AppLocalizations l10n) => [
        l10n.reasonScheduleClash,
        l10n.reasonNotAvailable,
        l10n.reasonChangeDoctor,
        l10n.reasonWeather,
        l10n.reasonOther,
      ];

  List<Map<String, dynamic>> buildTypes(AppLocalizations l10n) => [
        {'label': l10n.messaging, 'icon': Icons.chat_bubble_outline_rounded},
        {'label': l10n.voiceCall, 'icon': Icons.phone_rounded},
        {'label': l10n.videoCall, 'icon': Icons.videocam_rounded},
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.rescheduleAppointment),
        centerTitle: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: step == 0 ? 0.5 : 1.0,
            backgroundColor: colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(colorScheme.secondary),
          ),
        ),
      ),
      body: step == 0
          ? buildReasonStep(l10n)
          : buildDateStep(l10n),
    );
  }

  Widget buildReasonStep(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final reasons = buildReasons(l10n);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reasonForRescheduling,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  l10n.reasonForReschedulingSubtitle,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                ...reasons.asMap().entries.map((e) => ReasonOptionWidget(
                      label: e.value,
                      isSelected: selectedReason == e.key,
                      onTap: () => setState(() => selectedReason = e.key),
                    )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedReason != null
                  ? () => setState(() => step = 1)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedReason != null
                    ? colorScheme.secondary
                    : colorScheme.outline.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                l10n.next,
                style: TextStyle(
                  color: selectedReason != null
                      ? Colors.white
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateStep(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final types = buildTypes(l10n);
    final bool canConfirm = selectedDate != null && selectedTime != null;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalendarWidget(
                  focusedMonth: focusedMonth,
                  selectedDate: selectedDate,
                  onMonthChanged: (d) => setState(() => focusedMonth = d),
                  onDateSelected: (d) => setState(() => selectedDate = d),
                ),
                const SizedBox(height: 20),

                Text(l10n.availableTime,
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: times
                      .map((t) => TimeChipWidget(
                            time: t,
                            isSelected: selectedTime == t,
                            onTap: () => setState(() => selectedTime = t),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),

                Text(l10n.appointmentType,
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: types.asMap().entries.map((e) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: e.key < types.length - 1 ? 8 : 0),
                        child: AppointmentTypeChipWidget(
                          label: e.value['label'],
                          icon: e.value['icon'],
                          isSelected: selectedType == e.key,
                          onTap: () =>
                              setState(() => selectedType = e.key),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canConfirm ? () => Navigator.pop(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canConfirm
                    ? colorScheme.secondary
                    : colorScheme.outline.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                l10n.confirmReschedule,
                style: TextStyle(
                  color: canConfirm
                      ? Colors.white
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}