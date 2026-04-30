// lib/features/doctor_role/appointments/data/models/appointment_model.dart

enum AppointmentType { inPerson, videoCall }

enum AppointmentStatus { upcoming, completed, cancelled, pending }

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

  const DoctorAppointmentModel({
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

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    // Parse appointment type
    AppointmentType appointmentType = AppointmentType.inPerson;
    final typeRaw = (json['appointmentType'] ?? json['type'] ?? '').toString().toLowerCase();
    if (typeRaw.contains('video') || typeRaw.contains('online')) {
      appointmentType = AppointmentType.videoCall;
    }

    // Parse status
    AppointmentStatus appointmentStatus = AppointmentStatus.upcoming;
    final statusRaw = (json['status'] ?? '').toString().toLowerCase();
    if (statusRaw.contains('complet')) {
      appointmentStatus = AppointmentStatus.completed;
    } else if (statusRaw.contains('cancel')) {
      appointmentStatus = AppointmentStatus.cancelled;
    } else if (statusRaw.contains('pending')) {
      appointmentStatus = AppointmentStatus.pending;
    }

    // Parse date & time from scheduledDate or appointmentDate
    final rawDate = json['scheduledDate'] ?? json['appointmentDate'] ?? json['date'] ?? '';
    String formattedDate = '';
    String formattedTime = '';
    if (rawDate.toString().isNotEmpty) {
      try {
        final dt = DateTime.parse(rawDate.toString());
        formattedDate = '${_weekday(dt.weekday)}, ${_month(dt.month)} ${dt.day}';
        final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final minute = dt.minute.toString().padLeft(2, '0');
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        formattedTime = '$hour:$minute $period';
      } catch (_) {
        formattedDate = rawDate.toString();
      }
    }

    return DoctorAppointmentModel(
      id: (json['id'] ?? json['appointmentId'] ?? '').toString(),
      patientName: json['patientName'] ?? json['patient']?['name'] ?? json['patient']?['fullName'] ?? 'Unknown',
      patientAge: int.tryParse((json['patientAge'] ?? json['patient']?['age'] ?? 0).toString()) ?? 0,
      date: formattedDate,
      time: formattedTime,
      reason: json['reason'] ?? json['notes'] ?? json['description'] ?? 'General checkup',
      type: appointmentType,
      status: appointmentStatus,
      patientId: (json['patientId'] ?? json['patient']?['id'] ?? '').toString(),
    );
  }

  static String _weekday(int w) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(w - 1).clamp(0, 6)];
  }

  static String _month(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[(m - 1).clamp(0, 11)];
  }
}