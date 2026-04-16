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

  const NurseModel({
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
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();

    // Build initials from first letters
    final initials = [
      if (firstName.isNotEmpty) firstName[0],
      if (lastName.isNotEmpty) lastName[0],
    ].join().toUpperCase();

    return NurseModel(
      id: json['id']?.toString() ?? json['nurseId']?.toString() ?? '',
      name: fullName,
      specialty: json['specialization'] ?? 'General Care',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      yearsExperience: json['experienceYears'] ?? 0,
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      isAvailable: json['isActive'] ?? json['isAvailable'] ?? true,
      initials: initials.isNotEmpty ? initials : 'N',
      skills: List<String>.from(json['skills'] ?? []),
      completedJobs: json['completedJobs'] ?? 0,
    );
  }
}