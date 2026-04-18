import 'package:flutter/material.dart';

class VitalsFormWidget extends StatelessWidget {
  final TextEditingController bloodPressureController;
  final TextEditingController heartRateController;
  final TextEditingController temperatureController;
  final TextEditingController oxygenLevelController;

  const VitalsFormWidget({
    super.key,
    required this.bloodPressureController,
    required this.heartRateController,
    required this.temperatureController,
    required this.oxygenLevelController,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text(
            'Record Vitals',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          const SizedBox(height: 16),

          // ── Vitals Grid ──
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
            children: [
              _VitalField(
                controller: bloodPressureController,
                hint: 'Blood Pressure',
                unit: 'mmHg',
              ),
              _VitalField(
                controller: heartRateController,
                hint: 'Heart Rate',
                unit: 'bpm',
              ),
              _VitalField(
                controller: temperatureController,
                hint: 'Temperature',
                unit: '°C',
              ),
              _VitalField(
                controller: oxygenLevelController,
                hint: 'Oxygen Level',
                unit: '%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String unit;

  const _VitalField({
    required this.controller,
    required this.hint,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.inverseSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          suffixText: unit,
          suffixStyle: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
