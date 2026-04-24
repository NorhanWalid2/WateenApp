enum AlertType { critical, warning }

class DoctorDashboardStatsModel {
  final int todayAppointments;
  final int alerts;
  final int totalPatients;

  DoctorDashboardStatsModel({
    required this.todayAppointments,
    required this.alerts,
    required this.totalPatients,
  });
}

class PatientAlertModel {
  final String id;
  final String patientName;
  final String message;
  final AlertType type;

  PatientAlertModel({
    required this.id,
    required this.patientName,
    required this.message,
    required this.type,
  });
}

class ScheduleItemModel {
  final String id;
  final String patientName;
  final String visitType;
  final String time;
  final String initial;

  ScheduleItemModel({
    required this.id,
    required this.patientName,
    required this.visitType,
    required this.time,
    required this.initial,
  });
}
