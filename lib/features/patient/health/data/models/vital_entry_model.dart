class VitalEntryModel {
  final double value;
  final double? secondValue; // for blood pressure diastolic
  final DateTime time;
  final String unit;

  const VitalEntryModel({
    required this.value,
    this.secondValue,
    required this.time,
    required this.unit,
  });
}