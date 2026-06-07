// lib/features/doctor_role/patients/data/models/patient_model.dart

class PatientModel {
  final String id;
  final String name;
  final String initial;
  final String email;
  final String phoneNumber;
  final String gender;
  final String? dateOfBirth;
  final String? address;
  final String? profilePictureUrl;
  // Vitals
  final int? systolicPressure;
  final int? diastolicPressure;
  final int? heartRate;
  final int? sugar;

  // Legacy fields kept for compatibility
  final int age;
  final String condition;
  final String lastVisit;

  const PatientModel({
    required this.id,
    required this.name,
    required this.initial,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.dateOfBirth,
    this.address,
    this.profilePictureUrl,
    this.systolicPressure,
    this.diastolicPressure,
    this.heartRate,
    this.sugar,
    this.age = 0,
    this.condition = '',
    this.lastVisit = '',
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    final firstName = (json['firstName'] ?? '').toString();
    final lastName = (json['lastName'] ?? '').toString();
    final name = '$firstName $lastName'.trim();
    final initials = name.split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    // Calculate age from dateOfBirth
    int age = 0;
    final dob = json['dateOfBirth'];
    if (dob != null) {
      try {
        final dt = DateTime.parse(dob.toString());
        age = DateTime.now().difference(dt).inDays ~/ 365;
      } catch (_) {}
    }

    final bool isValidUrl = (json['profilePictureUrl']?.toString() ?? '')
        .startsWith('http');

    return PatientModel(
      id: (json['id'] ?? '').toString(),
      name: name.isEmpty ? 'Unknown' : name,
      initial: initials.isEmpty ? '?' : initials,
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      address: json['address']?.toString(),
      profilePictureUrl: isValidUrl ? json['profilePictureUrl'].toString() : null,
      systolicPressure: int.tryParse((json['systolicPressure'] ?? 0).toString()),
      diastolicPressure: int.tryParse((json['diastolicPressure'] ?? 0).toString()),
      heartRate: int.tryParse((json['heartRate'] ?? 0).toString()),
      sugar: int.tryParse((json['sugar'] ?? 0).toString()),
      age: age,
      condition: '',
      lastVisit: '',
    );
  }

  // Simple model for patients list (from PatientsForDoctor endpoint)
  factory PatientModel.fromListJson(Map<String, dynamic> json) {
    final firstName = (json['firstName'] ?? '').toString();
    final lastName = (json['lastName'] ?? '').toString();
    final name = '$firstName $lastName'.trim();
    final initials = name.split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return PatientModel(
      id: (json['id'] ?? '').toString(),
      name: name.isEmpty ? 'Unknown' : name,
      initial: initials.isEmpty ? '?' : initials,
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
    );
  }
}