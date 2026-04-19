enum HomeServiceStatus { pending, approved, rejected }

class HomeServiceManagementModel {
  final String id;
  final String name;
  final String role;
  final double rating;
  final int visitsCount;
  final String location;
  final String licenseNumber;
  final String appliedDate;
  final HomeServiceStatus status;

  HomeServiceManagementModel({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.visitsCount,
    required this.location,
    required this.licenseNumber,
    required this.appliedDate,
    required this.status,
  });

  String get initials =>
      name
          .split(' ')
          .where((e) => e.isNotEmpty)
          .take(2)
          .map((e) => e[0].toUpperCase())
          .join();
}
