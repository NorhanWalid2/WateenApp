// lib/features/doctor_role/prescriptions/data/prescription_model.dart

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

  const PrescriptionModel({
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

  // ── Static options for dropdowns ─────────────────────────────────
  static const List<String> frequencyOptions = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'Every 6 hours',
    'Every 8 hours',
    'As needed',
    'Weekly',
  ];

  static const List<String> durationOptions = [
    'Ongoing',
    '3 days',
    '5 days',
    '7 days',
    '10 days',
    '14 days',
    '1 month',
    '3 months',
    '6 months',
  ];

  // ── fromJson ──────────────────────────────────────────────────────
  // API returns: id, medicationName, dosage, frequency, duration,
  //              instructions, startDate, endDate, isActive
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    String formatDate(dynamic raw) {
      if (raw == null) return '';
      try {
        final dt = DateTime.parse(raw.toString()).toLocal();
        return '${dt.month}/${dt.day}/${dt.year}';
      } catch (_) {
        return raw.toString();
      }
    }

    final isActive = json['isActive'] ?? json['active'] ?? true;
    final status = (isActive == true || isActive == 1)
        ? PrescriptionStatus.active
        : PrescriptionStatus.past;

    return PrescriptionModel(
      id: (json['id'] ?? json['medicationId'] ?? '').toString(),
      medicationName: (json['medicationName'] ?? json['name'] ?? '').toString(),
      dosage: (json['dosage'] ?? '').toString(),
      frequency: (json['frequency'] ?? '').toString(),
      duration: (json['duration'] ?? 'Ongoing').toString(),
      instructions: (json['instructions'] ?? json['notes'] ?? '').toString(),
      startDate: formatDate(json['startDate'] ?? json['createdAt']),
      endDate: json['endDate'] != null ? formatDate(json['endDate']) : null,
      status: status,
    );
  }
}