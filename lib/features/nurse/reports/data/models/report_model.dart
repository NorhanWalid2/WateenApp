class ReportModel {
  final String id;
  final String fullName;
  final String? profilePictureUrl;
  final String? gender;
  final String? address;
  final String? dateOfBirth;

  ReportModel({
    required this.id,
    required this.fullName,
    this.profilePictureUrl,
    this.gender,
    this.address,
    this.dateOfBirth,
  });

  String get initials {
    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? 'Unknown').toString(),
      profilePictureUrl: json['profilePictureUrl']?.toString(),
      gender: json['gender']?.toString(),
      address: json['address']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
    );
  }
}