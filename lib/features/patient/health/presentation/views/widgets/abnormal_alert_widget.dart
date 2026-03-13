import 'package:flutter/material.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class AbnormalAlertWidget extends StatelessWidget {
  const AbnormalAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF3B1A1A)
            : const Color(0xFFFFF3F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF7B2C2C)
              : const Color(0xFFFFCDD2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFE53935), size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.abnormalReadingDetected,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.abnormalReadingDetails,
            style: textTheme.bodySmall?.copyWith(
              color: isDark
                  ? const Color(0xFFEF9A9A)
                  : const Color(0xFFB71C1C),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                l10n.contactDoctor,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}