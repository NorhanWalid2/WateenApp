// lib/features/patient/ai_assistant/data/models/diagnosis_model.dart

class DiagnosisResultItem {
  final String condition;
  final String? specialty;
  final String? description;
  final String? treatment;
  final String? whenToVisitDoctor;
  final double? score;

  DiagnosisResultItem({
    required this.condition,
    this.specialty,
    this.description,
    this.treatment,
    this.whenToVisitDoctor,
    this.score,
  });

  factory DiagnosisResultItem.fromJson(Map<String, dynamic> json) {
    return DiagnosisResultItem(
      condition: (json['المرض_المتوقع'] ?? json['condition'] ?? '').toString(),
      specialty: (json['التخصص_المناسب'] ?? json['specialty'])?.toString(),
      description: (json['نبذة'] ?? json['description'])?.toString(),
      treatment: (json['العلاج'] ?? json['treatment'])?.toString(),
      whenToVisitDoctor: (json['متى_تزور_الطبيب'])?.toString(),
      score: double.tryParse(
          (json['الدرجة'] ?? json['score'] ?? 0).toString()),
    );
  }
}

class DiagnosisModel {
  final bool success;
  final String? inputText;
  final List<DiagnosisResultItem> results;
  final List<String> redFlags;
  final String? note;

  DiagnosisModel({
    required this.success,
    this.inputText,
    required this.results,
    required this.redFlags,
    this.note,
  });

  bool get hasResults => results.isNotEmpty;

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    final success = (json['نجاح'] ?? json['success'] ?? false) == true;
    final inputText = (json['النص_المدخل'] ?? json['input_text'])?.toString();
    final note = (json['ملاحظة'] ?? json['note'])?.toString();

    final rawResults = json['النتائج'] ?? json['results'];
    List<DiagnosisResultItem> results = [];
    if (rawResults is List && rawResults.isNotEmpty) {
      // ✅ Take only the first result
      results = [
        DiagnosisResultItem.fromJson(
            rawResults.first as Map<String, dynamic>)
      ];
    }

    final rawFlags = json['علامات_تحذيرية'] ?? json['red_flags'];
    List<String> redFlags = [];
    if (rawFlags is List) {
      redFlags = rawFlags.map((e) => e.toString()).toList();
    }

    return DiagnosisModel(
      success: success,
      inputText: inputText,
      results: results,
      redFlags: redFlags,
      note: note,
    );
  }
}