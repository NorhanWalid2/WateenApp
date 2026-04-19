class DashboardStatsModel {
  final int totalPatients;
  final int activeDoctors;
  final int homeServices;
  final int appointmentsToday;
  final double patientsChange;
  final double doctorsChange;
  final double homeServicesChange;
  final double appointmentsChange;

  DashboardStatsModel({
    required this.totalPatients,
    required this.activeDoctors,
    required this.homeServices,
    required this.appointmentsToday,
    required this.patientsChange,
    required this.doctorsChange,
    required this.homeServicesChange,
    required this.appointmentsChange,
  });
}

class PendingApprovalModel {
  final String id;
  final String name;
  final String role;
  final String specialty;
  final String timeAgo;

  PendingApprovalModel({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
    required this.timeAgo,
  });
}

class RecentActivityModel {
  final String title;
  final String subtitle;
  final String timeAgo;
  final ActivityType type;

  RecentActivityModel({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.type,
  });
}

enum ActivityType { approved, registered, completed, rejected }
