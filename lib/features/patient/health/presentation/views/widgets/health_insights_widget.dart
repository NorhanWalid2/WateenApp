import 'package:flutter/material.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class HealthInsightsWidget extends StatelessWidget {
  const HealthInsightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final insights = [
      l10n.insightBpElevated,
      l10n.insightBloodSugarNormal,
      l10n.insightHeartRateGood,
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: insights
            .map((insight) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.circle,
                          size: 7,
                          color: colorScheme.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(insight,
                            style: textTheme.bodySmall),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}