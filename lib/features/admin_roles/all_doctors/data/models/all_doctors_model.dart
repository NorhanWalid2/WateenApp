class AllDoctorsModel {
  final String id;
  final String fullName;
  final String specialization;
  final String? bio;
  final String? profilePictureUrl;
  final String phoneNumber;
  final int experienceYears;

  AllDoctorsModel({
    required this.id,
    required this.fullName,
    required this.specialization,
    this.bio,
    this.profilePictureUrl,
    required this.phoneNumber,
    required this.experienceYears,
  });

  String get initials {
    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory AllDoctorsModel.fromJson(Map<String, dynamic> json) {
    return AllDoctorsModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      bio: json['bio']?.toString(),
      profilePictureUrl: json['profilePictureUrl']?.toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      experienceYears: (json['experienceYears'] as int?) ?? 0,
    );
  }
}