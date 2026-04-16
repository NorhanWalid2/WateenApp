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
          _SummaryItem(label: 'Nurse', value: nurseName),
          _Divider(color: colorScheme.secondary.withOpacity(0.25)),
          _SummaryItem(label: 'Type', value: serviceType),
          _Divider(color: colorScheme.secondary.withOpacity(0.25)),
          _SummaryItem(label: 'Rate', value: rate),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

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

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: color);
  }
}
