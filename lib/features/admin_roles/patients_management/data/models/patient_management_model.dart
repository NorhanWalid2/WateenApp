class PatientManagementModel {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String phone;
  final String lastVisit;
  final int appointmentsCount;

  PatientManagementModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
    required this.lastVisit,
    required this.appointmentsCount,
  });

  String get initials =>
      name
          .split(' ')
          .where((e) => e.isNotEmpty)
          .take(2)
          .map((e) => e[0].toUpperCase())
          .join();
}

class PatientStatsModel {
  final int totalPatients;
  final int activeThisMonth;
  final int newThisWeek;

  PatientStatsModel({
    required this.totalPatients,
    required this.activeThisMonth,
    required this.newThisWeek,
  });
}
