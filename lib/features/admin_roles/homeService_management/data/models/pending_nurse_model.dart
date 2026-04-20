class PendingNurseModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String licenseNumber;
  final int experienceYears;
  final int status;

  PendingNurseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.experienceYears,
    required this.status,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory PendingNurseModel.fromJson(Map<String, dynamic> json) {
    return PendingNurseModel(
      id: (json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      licenseNumber: (json['licenseNumber'] ?? '').toString(),
      experienceYears: (json['experienceYears'] as int?) ?? 0,
      status: (json['status'] as int?) ?? 0,
    );
  }
}