// lib/features/doctor_role/profile/data/models/doctor_profile_model.dart

class DoctorProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String specialization;
  final String licenseNumber;
  final String? bio;
  final String? education;
  final String? certifications;
  final String? workplace;
  final String? profilePictureUrl;
  final int experienceYears;

  const DoctorProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.specialization,
    required this.licenseNumber,
    this.bio,
    this.education,
    this.certifications,
    this.workplace,
    this.profilePictureUrl,
    this.experienceYears = 0,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).take(2);
    return parts.map((p) => p[0].toUpperCase()).join();
  }

  bool get hasValidProfilePicture =>
      profilePictureUrl != null &&
      (profilePictureUrl!.startsWith('http://') ||
          profilePictureUrl!.startsWith('https://'));

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    // GET /api/Profile/doctorData response:
    // { id, specialization, licenseNumber, bio, phoneNumber,
    //   availabilitySchedule, experienceYears, education,
    //   certifications, workplace }
    // firstName/lastName/email come from JWT or separate user object
    return DoctorProfileModel(
      id: (json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? json['first_name'] ?? '').toString(),
      lastName: (json['lastName'] ?? json['last_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      specialization: (json['specialization'] ?? json['specialty'] ?? '').toString(),
      licenseNumber: (json['licenseNumber'] ?? '').toString(),
      bio: json['bio']?.toString(),
      education: json['education']?.toString(),
      certifications: json['certifications']?.toString(),
      workplace: (json['workPlace'] ?? json['workplace'])?.toString(),
      // profilePictureUrl not in doctorData response — load from AppPrefs
      profilePictureUrl: json['profilePictureUrl']?.toString() ??
          json['profilePicture']?.toString(),
      experienceYears: int.tryParse((json['experienceYears'] ?? 0).toString()) ?? 0,
    );
  }
}