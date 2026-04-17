import 'package:flutter/material.dart';

class UrgencyBadgeWidget extends StatelessWidget {
  final bool isUrgent;

  const UrgencyBadgeWidget({super.key, required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent
            ? Theme.of(context).colorScheme.primaryContainer
            : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUrgent
              ? Theme.of(context).colorScheme.secondary
              : const Color(0xFFFFC107),
          width: 1,
        ),
      ),
      child: Text(
        isUrgent ? 'Urgent' : 'Normal',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isUrgent
              ? Theme.of(context).colorScheme.secondary
              : const Color(0xFFF59E0B),
        ),
      ),
    );
  }
}