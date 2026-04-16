class PatientProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? nationalId;
  final String? bloodType;

  PatientProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.phoneNumber,
    this.nationalId,
    this.bloodType,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      phoneNumber: json['phoneNumber'],
      nationalId: json['nationalId'],
      bloodType: json['bloodType'],
    );
  }
}