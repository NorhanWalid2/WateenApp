 
enum NurseRequestStatus { pending, approved, rejected }

class NurseRequestModel {
  final String id;
  final String serviceDescription;
  final String requestedTime;
  final String address;
  final int statusCode;
  final String patientId;
  final String nurseId;
  final String nurseName;
  final String? patientName;

  NurseRequestModel({
    required this.id,
    required this.serviceDescription,
    required this.requestedTime,
    required this.address,
    required this.statusCode,
    required this.patientId,
    required this.nurseId,
    required this.nurseName,
    this.patientName,
  });

  NurseRequestStatus get status {
    switch (statusCode) {
      case 1: return NurseRequestStatus.approved;
      case 2: return NurseRequestStatus.rejected;
      default: return NurseRequestStatus.pending;
    }
  }

  factory NurseRequestModel.fromJson(Map<String, dynamic> json) {
    return NurseRequestModel(
      id: (json['id'] ?? '').toString(),
      serviceDescription: (json['serviceDescription'] ?? '').toString(),
      requestedTime: (json['requestedTime'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      statusCode: (json['status'] as int?) ?? 0,
      patientId: (json['patientId'] ?? '').toString(),
      nurseId: (json['nurseId'] ?? '').toString(),
      nurseName: (json['nurseName'] ?? 'Unknown Nurse').toString(),
      patientName: json['patientName']?.toString(),
    );
  }
}