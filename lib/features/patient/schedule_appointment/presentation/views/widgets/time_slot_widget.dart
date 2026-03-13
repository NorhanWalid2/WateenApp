import 'package:flutter/material.dart';

enum TimeSlotStatus { available, selected, booked }

class TimeSlotWidget extends StatelessWidget {
  final String time;
  final TimeSlotStatus status;
  final VoidCallback onTap;

  const TimeSlotWidget({
    super.key,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = status == TimeSlotStatus.selected;
    final isBooked = status == TimeSlotStatus.booked;

    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D9488)
              : isBooked
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0D9488)
                : isBooked
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : isBooked
                    ? Theme.of(context).colorScheme.outlineVariant
                    : Theme.of(context).colorScheme.inverseSurface,
            decoration: isBooked ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}