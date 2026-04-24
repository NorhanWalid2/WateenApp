import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/checklist/data/models/checklist_model.dart';

class TaskCardWidget extends StatelessWidget {
  final ChecklistTaskModel task;
  final VoidCallback onToggle;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onToggle,
  });

  Color _priorityColor(BuildContext context) {
    switch (task.priority) {
      case TaskPriority.high:
        return Theme.of(context).colorScheme.secondary;
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return const Color(0xFF16A34A);
    }
  }

  String _priorityText() =>
      ChecklistTaskModel.priorityToString(task.priority);

  String _categoryText() =>
      ChecklistTaskModel.categoryToString(task.category);

  IconData _categoryIcon() {
    switch (task.category) {
      case TaskCategory.test:
        return Icons.science_outlined;
      case TaskCategory.appointment:
        return Icons.calendar_today_rounded;
      case TaskCategory.followUp:
        return Icons.refresh_rounded;
      case TaskCategory.medication:
        return Icons.medication_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    final isOverdue = task.isOverdue;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOverdue
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Checkbox ──
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFF16A34A)
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF16A34A)
                      : Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // ── Content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Title + Priority
                Row(
                  children: [
                    Icon(
                      _categoryIcon(),
                      size: 16,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Priority badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _priorityColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _priorityColor(context).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _priorityText(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _priorityColor(context),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Description
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),

                const SizedBox(height: 8),

                // Date + Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: isOverdue
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOverdue
                              ? '${_formatDate(task.dueDate)} (Overdue)'
                              : _formatDate(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isOverdue
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _categoryText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}