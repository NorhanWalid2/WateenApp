class NurseProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String profilePictureUrl;

  final String licenseNumber;
  final String specialization;
  final int experienceYears;
  final bool isActive;
  final int completedRequests;

  NurseProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.licenseNumber,
    required this.specialization,
    required this.experienceYears,
    required this.isActive,
    required this.completedRequests,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? userName : name;
  }

  String get initials {
    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'N';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  factory NurseProfileModel.fromJson({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> nurseJson,
  }) {
    return NurseProfileModel(
      id: (profileJson['id'] ?? nurseJson['id'] ?? '').toString(),
      firstName: (profileJson['firstName'] ?? '').toString(),
      lastName: (profileJson['lastName'] ?? '').toString(),
      userName: (profileJson['userName'] ?? '').toString(),
      email: (profileJson['email'] ?? '').toString(),
      phoneNumber:
          (profileJson['phoneNumber'] ?? nurseJson['phoneNumber'] ?? '')
              .toString(),
      profilePictureUrl: (profileJson['profilePictureUrl'] ?? '').toString(),
      licenseNumber: (nurseJson['licenseNumber'] ?? '').toString(),
      specialization: (nurseJson['specialization'] ?? 'Home Health Aide')
          .toString(),
      experienceYears: _toInt(nurseJson['experienceYears']),
      isActive: nurseJson['isActive'] as bool? ?? false,
      completedRequests: _toInt(nurseJson['completedRequests']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}