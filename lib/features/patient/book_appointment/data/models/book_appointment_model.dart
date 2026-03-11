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

  BookAppointmentModel({
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
}
