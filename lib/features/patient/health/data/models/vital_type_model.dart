import 'package:flutter/material.dart';

enum VitalType { bloodPressure, bloodSugar, heartRate, oxygen }

class VitalTypeModel {
  final VitalType type;
  final String label;
  final String unit;
  final IconData icon;
  final Color color;
  final String currentValue;
  final double min;
  final double max;

  const VitalTypeModel({
    required this.type,
    required this.label,
    required this.unit,
    required this.icon,
    required this.color,
    required this.currentValue,
    required this.min,
    required this.max,
  });
}