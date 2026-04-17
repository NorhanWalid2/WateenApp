import 'package:flutter/material.dart';

class StatsRowWidget extends StatelessWidget {
  final int totalHomeVisits;
  final int satisfactionPercent;
  final int yearsExperience;

  const StatsRowWidget({
    super.key,
    required this.totalHomeVisits,
    required this.satisfactionPercent,
    required this.yearsExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: totalHomeVisits.toString(),
            label: 'Home Visits',
          ),
          _Divider(),
          _StatItem(
            value: '$satisfactionPercent%',
            label: 'Satisfaction',
          ),
          _Divider(),
          _StatItem(
            value: yearsExperience.toString(),
            label: 'Years Exp.',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outlineVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context).colorScheme.surface,
    );
  }
}