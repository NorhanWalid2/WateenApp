class DoctorProfileModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final String email;
  final String phone;
  final String location;
  final List<DoctorQualificationModel> qualifications;
  final List<DoctorCertificationModel> certifications;
  final List<DoctorScheduleModel> schedule;
  final List<String> areasOfExpertise;
  final int totalPatients;
  final int successRate;

  DoctorProfileModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.yearsExperience,
    required this.email,
    required this.phone,
    required this.location,
    required this.qualifications,
    required this.certifications,
    required this.schedule,
    required this.areasOfExpertise,
    required this.totalPatients,
    required this.successRate,
  });

  String get initial => name[0].toUpperCase();
}

class DoctorQualificationModel {
  final String degree;
  final String institution;

  DoctorQualificationModel({
    required this.degree,
    required this.institution,
  });
}

class DoctorCertificationModel {
  final String title;
  final String issuedBy;

  DoctorCertificationModel({
    required this.title,
    required this.issuedBy,
  });
}

class DoctorScheduleModel {
  final String days;
  final String startTime;
  final String endTime;
  final bool isEnabled;

  DoctorScheduleModel({
    required this.days,
    required this.startTime,
    required this.endTime,
    this.isEnabled = true,
  });
}