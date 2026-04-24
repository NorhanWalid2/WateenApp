enum TaskPriority { high, medium, low }
enum TaskCategory { test, appointment, followUp, medication }
enum TaskStatus { pending, completed }

class ChecklistTaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final TaskStatus status;

  ChecklistTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    required this.status,
  });

  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) && status == TaskStatus.pending;

  static const List<String> priorityOptions = ['High', 'Medium', 'Low'];

  static const List<String> categoryOptions = [
    'Test',
    'Appointment',
    'Follow-up',
    'Medication',
  ];

  static TaskPriority priorityFromString(String value) {
    switch (value.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'low':
        return TaskPriority.low;
      default:
        return TaskPriority.medium;
    }
  }

  static TaskCategory categoryFromString(String value) {
    switch (value.toLowerCase()) {
      case 'test':
        return TaskCategory.test;
      case 'appointment':
        return TaskCategory.appointment;
      case 'medication':
        return TaskCategory.medication;
      default:
        return TaskCategory.followUp;
    }
  }

  static String priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.low:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  static String categoryToString(TaskCategory category) {
    switch (category) {
      case TaskCategory.test:
        return 'Test';
      case TaskCategory.appointment:
        return 'Appointment';
      case TaskCategory.medication:
        return 'Medication';
      default:
        return 'Follow-up';
    }
  }
}