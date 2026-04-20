class PendingDoctorModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String licenseNumber;
  final String workPlace;
  final int experienceYears;
  final int status;

  PendingDoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.workPlace,
    required this.experienceYears,
    required this.status,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory PendingDoctorModel.fromJson(Map<String, dynamic> json) {
    return PendingDoctorModel(
      id: (json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      licenseNumber: (json['licenseNumber'] ?? '').toString(),
      workPlace: (json['workPlace'] ?? '').toString(),
      experienceYears: (json['experienceYears'] as int?) ?? 0,
      status: (json['status'] as int?) ?? 0,
    );
  }
}