class NurseRequestModel {
  final String id;
  final String patientName;
  final String serviceType;
  final String location;
  final double distanceKm;
  final String date;
  final String time;
  final int durationHours;
  final double price;
  final bool isUrgent;

  NurseRequestModel({
    required this.id,
    required this.patientName,
    required this.serviceType,
    required this.location,
    required this.distanceKm,
    required this.date,
    required this.time,
    required this.durationHours,
    required this.price,
    required this.isUrgent,
  });
}
