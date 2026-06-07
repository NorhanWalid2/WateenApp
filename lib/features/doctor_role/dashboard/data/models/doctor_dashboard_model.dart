// lib/features/doctor_role/dashboard/data/models/doctor_dashboard_model.dart

class DoctorDashboardModel {
  final int totalPatients;
  final int todayAppointmentsCount;
  final int totalUpcoming;
  final List<TodayAppointmentModel> todaySchedule;

  const DoctorDashboardModel({
    required this.totalPatients,
    required this.todayAppointmentsCount,
    required this.totalUpcoming,
    required this.todaySchedule,
  });
}

class TodayAppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientInitials;
  final String time;
  final String reason;
  final String appointmentType; // VideoCall / InPerson
  final String status;
  final String? calendlyJoinUrl;

  const TodayAppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientInitials,
    required this.time,
    required this.reason,
    required this.appointmentType,
    required this.status,
    this.calendlyJoinUrl,
  });

  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) {
    // API shape:
    // { id, patientId, patientName, appointmentTime, type, status (int),
    //   notes, videoCallLink, doctorSpecialization }

    final name = (json['patientName'] ?? 'Unknown').toString().trim();

    final initials = name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    // appointmentTime: "2026-05-27T06:00:00"
    final rawDate = json['appointmentTime'] ??
        json['scheduledDate'] ??
        json['appointmentDate'] ??
        '';

    String formattedTime = '';
    String formattedDate = '';
    try {
      final dt = DateTime.parse(rawDate.toString()).toLocal();
      final hour =
          dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      formattedTime = '$hour:$minute $period';
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      formattedDate = '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      formattedTime = rawDate.toString();
    }

    // status is int: 0=Pending,1=Accepted,2=Cancelled,3=Upcoming,4=Completed
    final statusRaw = json['status'];
    final statusInt = int.tryParse((statusRaw ?? 0).toString()) ?? 0;
    final statusLabel = _statusFromInt(statusInt);

    // type: "video" / "inPerson"
    final typeRaw = (json['type'] ?? json['appointmentType'] ?? 'video')
        .toString()
        .toLowerCase();

    return TodayAppointmentModel(
      id: (json['id'] ?? '').toString(),
      patientId: (json['patientId'] ?? '').toString(),
      patientName: name.isEmpty ? 'Unknown' : name,
      patientInitials: initials.isEmpty ? '?' : initials,
      time: formattedDate.isNotEmpty
          ? '$formattedDate · $formattedTime'
          : formattedTime,
      reason: (json['notes'] ?? json['reason'] ?? 'General checkup').toString(),
      appointmentType: typeRaw.contains('video') ? 'VideoCall' : 'InPerson',
      status: statusLabel,
      // videoCallLink: Google Meet URL from Calendly
      calendlyJoinUrl: json['videoCallLink']?.toString() ??
          json['calendlyJoinUrl']?.toString() ??
          json['joinUrl']?.toString(),
    );
  }

  static String _statusFromInt(int status) {
    switch (status) {
      case 0: return 'Pending';
      case 1: return 'Accepted';
      case 2: return 'Cancelled';
      case 3: return 'Upcoming';
      case 4: return 'Completed';
      default: return 'Scheduled';
    }
  }
}