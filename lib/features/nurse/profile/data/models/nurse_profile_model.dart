class NurseProfileModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final String email;
  final String phone;
  final String serviceArea;
  final List<QualificationModel> qualifications;
  final List<CertificationModel> certifications;
  final List<ScheduleModel> schedule;
  final List<String> servicesOffered;
  final int totalHomeVisits;
  final int satisfactionPercent;

  NurseProfileModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.yearsExperience,
    required this.email,
    required this.phone,
    required this.serviceArea,
    required this.qualifications,
    required this.certifications,
    required this.schedule,
    required this.servicesOffered,
    required this.totalHomeVisits,
    required this.satisfactionPercent,
  });
}

class QualificationModel {
  final String title;
  final String institution;

  QualificationModel({
    required this.title,
    required this.institution,
  });
}

class CertificationModel {
  final String title;
  final String issuedBy;

  CertificationModel({
    required this.title,
    required this.issuedBy,
  });
}

class ScheduleModel {
  final String days;
  final String hours;
  final bool isClosed;

  ScheduleModel({
    required this.days,
    required this.hours,
    this.isClosed = false,
  });
}