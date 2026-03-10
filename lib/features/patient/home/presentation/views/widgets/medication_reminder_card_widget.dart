import 'package:flutter/material.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class MedicationReminderCardWidget extends StatelessWidget {
  final String medicationName;
  final String instructions;
  final VoidCallback onMarkAsTaken;
  final VoidCallback onRemindLater;

  const MedicationReminderCardWidget({
    super.key,
    required this.medicationName,
    required this.instructions,
    required this.onMarkAsTaken,
    required this.onRemindLater,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ بيتغير حسب الثيم
        color: isDark
            ? const Color(0xFF2C2410)
            : const Color(0xFFFFFBEB),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.medicationReminder,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  // ✅ لون النص بيتغير حسب الثيم
                  color: isDark
                      ? const Color(0xFFFFD95A)
                      : const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            medicationName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? const Color(0xFFFFD95A)
                  : const Color(0xFF92400E),
            ),
          ),
          Text(
            instructions,
            style: textTheme.bodySmall?.copyWith(
              color: isDark
                  ? const Color(0xFFB8A060)
                  : const Color(0xFF78350F),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onMarkAsTaken,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.markAsTaken,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onRemindLater,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    l10n.remindLater,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}