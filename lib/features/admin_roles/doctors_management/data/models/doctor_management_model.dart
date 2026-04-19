enum DoctorStatus { pending, approved, rejected }

class DoctorManagementModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int patientCount;
  final String location;
  final String licenseNumber;
  final String appliedDate;
  final DoctorStatus status;

  DoctorManagementModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.patientCount,
    required this.location,
    required this.licenseNumber,
    required this.appliedDate,
    required this.status,
  });

  String get initials =>
      name
          .split(' ')
          .where((e) => e.isNotEmpty)
          .take(2)
          .map((e) => e[0].toUpperCase())
          .join();
}
