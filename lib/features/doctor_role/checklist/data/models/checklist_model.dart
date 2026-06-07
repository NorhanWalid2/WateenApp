// lib/features/doctor_role/checklist/data/models/checklist_model.dart

enum TaskPriority { high, medium, low }
enum TaskCategory { test, appointment, medication, followUp, other }
enum TaskStatus { pending, completed }

class ChecklistTaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final TaskStatus status;

  const ChecklistTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    required this.status,
  });

  // ── Computed ──────────────────────────────────────────────────────
  bool get isOverdue =>
      status == TaskStatus.pending && dueDate.isBefore(DateTime.now());

  // ── Static options for dropdowns ─────────────────────────────────
  static const List<String> priorityOptions = ['High', 'Medium', 'Low'];
  static const List<String> categoryOptions = [
    'Test', 'Appointment', 'Medication', 'Follow Up', 'Other'
  ];

  // ── String converters ─────────────────────────────────────────────
  static String priorityToString(TaskPriority p) {
    switch (p) {
      case TaskPriority.high: return 'High';
      case TaskPriority.medium: return 'Medium';
      case TaskPriority.low: return 'Low';
    }
  }

  static TaskPriority priorityFromString(String s) {
    switch (s.toLowerCase()) {
      case 'high': return TaskPriority.high;
      case 'low': return TaskPriority.low;
      default: return TaskPriority.medium;
    }
  }

  static String categoryToString(TaskCategory c) {
    switch (c) {
      case TaskCategory.test: return 'Test';
      case TaskCategory.appointment: return 'Appointment';
      case TaskCategory.medication: return 'Medication';
      case TaskCategory.followUp: return 'Follow Up';
      case TaskCategory.other: return 'Other';
    }
  }

  static TaskCategory categoryFromString(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('test')) return TaskCategory.test;
    if (lower.contains('appoint')) return TaskCategory.appointment;
    if (lower.contains('med')) return TaskCategory.medication;
    if (lower.contains('follow')) return TaskCategory.followUp;
    return TaskCategory.other;
  }

  // ── fromJson ──────────────────────────────────────────────────────
  // API returns: taskTitle, taskDescription, dueDate, priority, category, isCompleted
  factory ChecklistTaskModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic raw) {
      try {
        return DateTime.parse((raw ?? '').toString()).toLocal();
      } catch (_) {
        return DateTime.now().add(const Duration(days: 7));
      }
    }

    final isCompleted = json['isCompleted'] ?? json['completed'] ?? false;

    return ChecklistTaskModel(
      id: (json['id'] ?? json['taskId'] ?? '').toString(),
      title: (json['taskTitle'] ?? json['title'] ?? '').toString(),
      description: (json['taskDescription'] ?? json['description'] ?? json['notes'] ?? '').toString(),
      dueDate: parseDate(json['dueDate'] ?? json['due_date']),
      priority: priorityFromString((json['priority'] ?? 'medium').toString()),
      category: categoryFromString((json['category'] ?? 'other').toString()),
      status: (isCompleted == true || isCompleted == 1)
          ? TaskStatus.completed
          : TaskStatus.pending,
    );
  }
}