class ReportModel {
  final String id;
  final String patientName;
  final String dateTime;
  final String location;
  final bool vitalsRecorded;
  final String status;

  ReportModel({
    required this.id,
    required this.patientName,
    required this.dateTime,
    required this.location,
    required this.vitalsRecorded,
    required this.status,
  });
}