enum PrescriptionStatus { active, past }

class PrescriptionModel {
  final String id;
  final String medicationName;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final String startDate;
  final String? endDate;
  final PrescriptionStatus status;

  PrescriptionModel({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.startDate,
    this.endDate,
    required this.status,
  });

  static const List<String> frequencyOptions = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'Every 4 hours',
    'Every 6 hours',
    'Every 8 hours',
    'Every 12 hours',
    'As needed',
  ];

  static const List<String> durationOptions = [
    'Ongoing',
    '3 days',
    '5 days',
    '7 days',
    '10 days',
    '14 days',
    '30 days',
    '60 days',
    '90 days',
  ];
}