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
  final String? videoCallLink;
  final String? notes;
  final String? doctorId;

  const AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.avatarInitials,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    this.videoCallLink,
    this.notes, this.doctorId,
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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // ── Parse date & time from appointmentTime ──
    String date = '';
    String time = '';
    try {
      final dt = DateTime.parse(
              json['appointmentTime'] ?? '')
          .toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      date =
          '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      final h =
          dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m =
          dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      time = '$h:$m $ampm';
    } catch (_) {}

    // ── Parse type ──
    AppointmentType type;
    switch ((json['type'] ?? '').toString().toLowerCase()) {
      case 'video':
        type = AppointmentType.video;
        break;
      case 'inperson':
        type = AppointmentType.inPerson;
        break;
      default:
        type = AppointmentType.message;
    }

    // ── Parse status ──
    // status 1 = upcoming, 3 = completed/past
    final statusCode = (json['status'] as int?) ?? 1;
    final status = statusCode == 3
        ? AppointmentStatus.past
        : AppointmentStatus.upcoming;

    // ── Avatar initials from doctor name ──
    final doctorName =
        (json['doctorName'] ?? '').toString();
    final nameParts = doctorName
        .replaceAll('Dr.', '')
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'
            .toUpperCase()
        : doctorName.isNotEmpty
            ? doctorName[0].toUpperCase()
            : '?';

    return AppointmentModel(
      id: (json['id'] ?? '').toString(),
      doctorName: doctorName,
      specialty:
          (json['doctorSpecialization'] ?? '').toString(),
      avatarInitials: initials,
      date: date,
      time: time,
      type: type,
      status: status,
      videoCallLink:
          json['videoCallLink']?.toString(),
      notes: json['notes']?.toString(),
      doctorId: json['doctorId']?.toString(),
    );
  }
}