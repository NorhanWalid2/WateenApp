class NurseModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final double hourlyRate;
  final bool isAvailable;
  final String initials;
  final List<String> skills;
  final int completedJobs;

  NurseModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.yearsExperience,
    required this.hourlyRate,
    required this.isAvailable,
    required this.initials,
    required this.skills,
    required this.completedJobs,
  });

  factory NurseModel.fromJson(Map<String, dynamic> json) {
    final fullName =
        (json['name'] ??
                json['fullName'] ??
                json['nurseName'] ??
                '')
            .toString();

    return NurseModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      name: fullName,
      specialty: (json['specialty'] ??
              json['serviceType'] ??
              json['specialization'] ??
              'Nurse')
          .toString(),
      rating: _toDouble(json['rating']),
      reviewCount: _toInt(json['reviewCount']),
      yearsExperience: _toInt(
        json['yearsExperience'] ?? json['experienceYears'],
      ),
      hourlyRate: _toDouble(json['hourlyRate'] ?? json['pricePerHour']),
      isAvailable: json['isAvailable'] ?? json['available'] ?? true,
      initials: _buildInitials(fullName),
      skills: _parseSkills(json['skills']),
      completedJobs: _toInt(
        json['completedJobs'] ?? json['completedSessions'],
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static List<String> _parseSkills(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static String _buildInitials(String name) {
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'N';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}