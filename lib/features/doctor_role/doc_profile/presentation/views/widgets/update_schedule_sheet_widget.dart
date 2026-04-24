import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';

class UpdateScheduleSheetWidget extends StatefulWidget {
  final List<DoctorScheduleModel> schedule;
  final Function(List<DoctorScheduleModel>) onSave;

  const UpdateScheduleSheetWidget({
    super.key,
    required this.schedule,
    required this.onSave,
  });

  @override
  State<UpdateScheduleSheetWidget> createState() =>
      _UpdateScheduleSheetWidgetState();
}

class _UpdateScheduleSheetWidgetState
    extends State<UpdateScheduleSheetWidget> {
  late List<Map<String, dynamic>> _scheduleData;

  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _scheduleData = _days.map((day) {
      final existing = widget.schedule.firstWhere(
        (s) => s.days.contains(day),
        orElse: () => DoctorScheduleModel(
          days: day,
          startTime: '09:00 AM',
          endTime: '05:00 PM',
          isEnabled: false,
        ),
      );
      return {
        'day': day,
        'isEnabled': existing.isEnabled,
        'startTime': existing.startTime,
        'endTime': existing.endTime,
      };
    }).toList();
  }

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
        children: [

          // ── Title ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Update Schedule',
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

          // ── Days list ──
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: _scheduleData.length,
              itemBuilder: (context, index) {
                final data = _scheduleData[index];
                final isEnabled = data['isEnabled'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day + Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['day'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface,
                            ),
                          ),
                          Switch(
                            value: isEnabled,
                            onChanged: (val) =>
                                setState(() => data['isEnabled'] = val),
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),

                      // Time fields — only when enabled
                      if (isEnabled) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _TimeField(
                                label: 'Start Time',
                                value: data['startTime'] as String,
                                onChanged: (val) =>
                                    setState(() => data['startTime'] = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TimeField(
                                label: 'End Time',
                                value: data['endTime'] as String,
                                onChanged: (val) =>
                                    setState(() => data['endTime'] = val),
                              ),
                            ),
                          ],
                        ),
                      ],

                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        thickness: 1,
                        height: 16,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Save button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                final saved = _scheduleData.map((data) {
                  return DoctorScheduleModel(
                    days: data['day'] as String,
                    startTime: data['startTime'] as String,
                    endTime: data['endTime'] as String,
                    isEnabled: data['isEnabled'] as bool,
                  );
                }).toList();
                widget.onSave(saved);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.save_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Save Schedule',
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
        ],
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _TimeField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.outlineVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final now = TimeOfDay.now();
            final picked = await showTimePicker(
              context: context,
              initialTime: now,
            );
            if (picked != null) {
              final formatted = picked.format(context);
              onChanged(formatted);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}