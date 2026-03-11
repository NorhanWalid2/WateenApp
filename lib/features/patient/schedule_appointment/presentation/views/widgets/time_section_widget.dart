import 'package:flutter/material.dart';
import 'time_slot_widget.dart';

class TimeSectionWidget extends StatelessWidget {
  final String period;
  final List<String> times;
  final List<String> bookedTimes;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  const TimeSectionWidget({
    super.key,
    required this.period,
    required this.times,
    required this.bookedTimes,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              period.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.outlineVariant,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.surface,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.6,
          ),
          itemCount: times.length,
          itemBuilder: (context, index) {
            final time = times[index];
            final isBooked = bookedTimes.contains(time);
            final isSelected = time == selectedTime;
            return TimeSlotWidget(
              time: time,
              status: isBooked
                  ? TimeSlotStatus.booked
                  : isSelected
                      ? TimeSlotStatus.selected
                      : TimeSlotStatus.available,
              onTap: () => onTimeSelected(time),
            );
          },
        ),
      ],
    );
  }
}