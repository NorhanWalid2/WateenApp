// lib/features/patient/medical_records/data/models/medical_record_model.dart

enum MedicalRecordType { all, labResult, doctorNote, history, imaging }

class MedicalRecordModel {
  final String id;
  final String title;
  final MedicalRecordType type;
  final String? doctorName;
  final DateTime date;
  final String? description;
  final String? fileUrl;

  const MedicalRecordModel({
    required this.id,
    required this.title,
    required this.type,
    this.doctorName,
    required this.date,
    this.description,
    this.fileUrl,
  });

  bool get addedByPatient => doctorName == null || doctorName!.isEmpty;

  String get typeLabel {
    switch (type) {
      case MedicalRecordType.labResult: return 'Lab result';
      case MedicalRecordType.doctorNote: return 'Doctor note';
      case MedicalRecordType.history: return 'Medical history';
      case MedicalRecordType.imaging: return 'Imaging';
      case MedicalRecordType.all: return 'All';
    }
  }

  // API recordType string → enum
  static MedicalRecordType typeFromString(String? s) {
    switch ((s ?? '').toLowerCase().replaceAll(' ', '')) {
      case 'labresult': return MedicalRecordType.labResult;
      case 'doctornote': return MedicalRecordType.doctorNote;
      case 'history':
      case 'medicalhistory': return MedicalRecordType.history;
      case 'imaging': return MedicalRecordType.imaging;
      default: return MedicalRecordType.history;
    }
  }

  // enum → API recordType string
  static String typeToApiString(MedicalRecordType t) {
    switch (t) {
      case MedicalRecordType.labResult: return 'Lab Result';
      case MedicalRecordType.doctorNote: return 'Doctor Note';
      case MedicalRecordType.history: return 'History';
      case MedicalRecordType.imaging: return 'Imaging';
      case MedicalRecordType.all: return '';
    }
  }

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic raw) {
      try { return DateTime.parse(raw.toString()).toLocal(); }
      catch (_) { return DateTime.now(); }
    }

    return MedicalRecordModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? json['recordTitle'] ?? json['name'] ?? '').toString(),
      type: typeFromString(json['recordType']?.toString() ?? json['type']?.toString()),
      doctorName: json['doctorName']?.toString(),
      date: parseDate(json['date'] ?? json['createdAt']),
      description: json['description']?.toString() ?? json['notes']?.toString(),
      fileUrl: json['fileUrl']?.toString() ?? json['url']?.toString(),
    );
  }
}