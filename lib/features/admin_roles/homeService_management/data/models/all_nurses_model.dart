class AllNursesModel {
  final String id;
  final String fullName;
  final String specialization;
  final int experienceYears;
  final String? profilePictureUrl;
  final String phoneNumber;

  AllNursesModel({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.experienceYears,
    this.profilePictureUrl,
    required this.phoneNumber,
  });

  String get initials {
    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory AllNursesModel.fromJson(Map<String, dynamic> json) {
    return AllNursesModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      experienceYears: (json['experienceYears'] as int?) ?? 0,
      profilePictureUrl: json['profilePictureUrl']?.toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
    );
  }
}