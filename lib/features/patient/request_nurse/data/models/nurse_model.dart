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
}
