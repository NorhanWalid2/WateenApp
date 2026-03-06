enum AppointmentType { video, inPerson, message }

enum AppointmentStatus { upcoming, past }

class AppointmentModel {
  final String id;
  final String doctorName;
  final String specialty;
  final String avatarInitials;
  final String date;
  final String time;
  final AppointmentType type;
  final AppointmentStatus status;

  const AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.avatarInitials,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });

  String get typeLabel {
    switch (type) {
      case AppointmentType.video:
        return 'Video Consultation';
      case AppointmentType.inPerson:
        return 'In-Person Visit';
      case AppointmentType.message:
        return 'Message Consultation';
    }
  }
}