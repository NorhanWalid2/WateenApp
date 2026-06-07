// lib/features/patient/medications/data/models/patient_medication_model.dart

class PatientMedicationModel {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final String startDate;
  final String? endDate;
  final bool isActive;

  const PatientMedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory PatientMedicationModel.fromJson(Map<String, dynamic> json) {
    String formatDate(dynamic raw) {
      if (raw == null) return '';
      try {
        final dt = DateTime.parse(raw.toString()).toLocal();
        return '${dt.month}/${dt.day}/${dt.year}';
      } catch (_) {
        return raw.toString();
      }
    }

    return PatientMedicationModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['medicationName'] ?? '').toString(),
      dosage: (json['dosage'] ?? '').toString(),
      frequency: (json['frequency'] ?? '').toString(),
      duration: (json['duration'] ?? 'Ongoing').toString(),
      instructions: (json['instructions'] ?? '').toString(),
      startDate: formatDate(json['startDate'] ?? json['createdAt']),
      endDate: json['endDate'] != null ? formatDate(json['endDate']) : null,
      isActive: json['isActive'] ?? true,
    );
  }
}