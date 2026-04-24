class BookAppointmentModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final double consultationFee;
  final bool isAvailable;
  final String initials;

  const BookAppointmentModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.yearsExperience,
    required this.consultationFee,
    required this.isAvailable,
    required this.initials,
  });

  factory BookAppointmentModel.fromJson(Map<String, dynamic> json) {
  final rawName = (json['fullName'] ??
          json['name'] ??
          '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}')
      .toString()
      .trim();

  final displayName =
      rawName.isEmpty ? 'Dr. Unknown' : 'Dr. $rawName';

  final parts = rawName.split(' ').where((e) => e.isNotEmpty).toList();

  final initials = parts.length >= 2
      ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
      : parts.isNotEmpty
          ? parts[0][0].toUpperCase()
          : 'DR';

  return BookAppointmentModel(
    id: json['id']?.toString() ?? json['doctorId']?.toString() ?? '',
    name: displayName,
    specialty: (json['specialization'] ?? json['specialty'] ?? 'General').toString(),
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
    reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    yearsExperience:
        (json['experienceYears'] ?? json['yearsExperience'] as num?)?.toInt() ?? 0,
    consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0,
    isAvailable: json['isAvailable'] as bool? ?? true,
    initials: initials,
  );
}
}