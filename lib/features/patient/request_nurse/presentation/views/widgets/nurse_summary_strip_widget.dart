import 'package:flutter/material.dart';

class NurseSummaryStripWidget extends StatelessWidget {
  final String nurseName;
  final String serviceType;
  final String rate;

  const NurseSummaryStripWidget({
    super.key,
    required this.nurseName,
    required this.serviceType,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.secondary.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SummaryItemWidget(label: 'Nurse', value: nurseName),
          SummaryDividerWidget(color: colorScheme.secondary.withOpacity(0.25)),
          SummaryItemWidget(label: 'Type', value: serviceType),
          SummaryDividerWidget(color: colorScheme.secondary.withOpacity(0.25)),
          SummaryItemWidget(label: 'Rate', value: rate),
        ],
      ),
    );
  }
}

class SummaryItemWidget extends StatelessWidget {
  final String label;
  final String value;

  const SummaryItemWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class SummaryDividerWidget extends StatelessWidget {
  final Color color;

  const SummaryDividerWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: color);
  }
}
