class PatientDetailsModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String patientId;
  final List<double> bloodPressureReadings;
  final List<String> medicalHistory;
  final int medicationAdherencePercent;

  PatientDetailsModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.patientId,
    required this.bloodPressureReadings,
    required this.medicalHistory,
    required this.medicationAdherencePercent,
  });

  String get initial => name[0].toUpperCase();
}