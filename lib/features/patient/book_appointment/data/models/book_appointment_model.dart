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
    final firstName = json['firstName'] ?? '';
    final lastName  = json['lastName']  ?? '';
    final fullName  = '$firstName $lastName'.trim();
    final initials  = [
      if (firstName.isNotEmpty) firstName[0],
      if (lastName.isNotEmpty)  lastName[0],
    ].join().toUpperCase();

    return BookAppointmentModel(
      id:               json['id']?.toString() ?? json['doctorId']?.toString() ?? '',
      name:             fullName.isEmpty ? 'Dr. Unknown' : 'Dr. $fullName',
      specialty:        json['specialization'] ?? json['specialty'] ?? 'General',
      rating:           (json['rating']          ?? 0).toDouble(),
      reviewCount:      json['reviewCount']       ?? 0,
      yearsExperience:  json['experienceYears']   ?? json['yearsExperience'] ?? 0,
      consultationFee:  (json['consultationFee']  ?? 0).toDouble(),
      isAvailable:      json['isAvailable']       ?? true,
      initials:         initials.isEmpty ? 'DR' : initials,
    );
  }
}