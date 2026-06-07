enum PatientTaskPriority { high, medium, low }
 
class PatientTaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String category;
  final bool isCompleted;
 
  const PatientTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    required this.isCompleted,
  });
 
  bool get isOverdue =>
      !isCompleted && dueDate.isBefore(DateTime.now());
 
  factory PatientTaskModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic raw) {
      try {
        return DateTime.parse((raw ?? '').toString()).toLocal();
      } catch (_) {
        return DateTime.now().add(const Duration(days: 7));
      }
    }
 
    return PatientTaskModel(
      id: (json['id'] ?? json['taskId'] ?? '').toString(),
      title: (json['taskTitle'] ?? json['title'] ?? '').toString(),
      description: (json['taskDescription'] ?? json['description'] ?? '').toString(),
      dueDate: parseDate(json['dueDate']),
      priority: (json['priority'] ?? 'Medium').toString(),
      category: (json['category'] ?? 'Other').toString(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}