class ActiveVisitModel {
  final String patientName;
  final String address;
  final String phoneNumber;

  ActiveVisitModel({
    required this.patientName,
    required this.address,
    required this.phoneNumber,
  });
}

class VitalsModel {
  final String bloodPressure;
  final String heartRate;
  final String temperature;
  final String oxygenLevel;

  VitalsModel({
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
    required this.oxygenLevel,
  });
}
