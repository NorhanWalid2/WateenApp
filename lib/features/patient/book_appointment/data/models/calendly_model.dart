class CalendlyEventTypeModel {
  final String uri;
  final String name;
  final int duration;
  final String schedulingUrl;
  final String? description;
  final bool active;

  CalendlyEventTypeModel({
    required this.uri,
    required this.name,
    required this.duration,
    required this.schedulingUrl,
    this.description,
    required this.active,
  });

  factory CalendlyEventTypeModel.fromJson(Map<String, dynamic> json) {
    return CalendlyEventTypeModel(
      uri: (json['uri'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      duration: (json['duration'] as int?) ?? 30,
      schedulingUrl: (json['scheduling_url'] ?? '').toString(),
      description: json['description_plain']?.toString(),
      active: (json['active'] as bool?) ?? true,
    );
  }
}