class PatientProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? address;
  final String? profilePictureUrl;
  final String? dateOfBirth;
  // Read-only fields (from GET, not sent in PUT)
  final String? gender;
  final String? phoneNumber;
  final String? nationalId;
  final String? bloodType;
  final int? systolicPressure;
  final int? diastolicPressure;
  final int? heartRate;
  final int? sugar;

  PatientProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.address,
    this.profilePictureUrl,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.nationalId,
    this.bloodType,
    this.systolicPressure,
    this.diastolicPressure,
    this.heartRate,
    this.sugar,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      firstName:         json['firstName'] ?? '',
      lastName:          json['lastName'] ?? '',
      email:             json['email'] ?? '',
      address:           json['address'],
      profilePictureUrl: json['profilePictureUrl'],
      dateOfBirth:       json['dateOfBirth'],
      gender:            json['gender'],
      phoneNumber:       json['phoneNumber'],
      nationalId:        json['nationalId'],
      bloodType:         json['bloodType'],
      systolicPressure:  json['systolicPressure'],
      diastolicPressure: json['diastolicPressure'],
      heartRate:         json['heartRate'],
      sugar:             json['sugar'],
    );
  }
}