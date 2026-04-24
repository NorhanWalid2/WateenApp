enum AppointmentType { inPerson, videoCall }
enum AppointmentStatus { upcoming, completed }

class DoctorAppointmentModel {
  final String id;
  final String patientName;
  final int patientAge;
  final String date;
  final String time;
  final String reason;
  final AppointmentType type;
  final AppointmentStatus status;
  final String patientId;

  DoctorAppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.date,
    required this.time,
    required this.reason,
    required this.type,
    required this.status,
    required this.patientId,
  });

  String get initials => patientName
      .split(' ')
      .where((e) => e.isNotEmpty)
      .take(2)
      .map((e) => e[0].toUpperCase())
      .join();
}