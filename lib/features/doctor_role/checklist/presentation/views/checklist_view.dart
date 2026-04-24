import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import '../../data/models/checklist_model.dart';
import 'widgets/checklist_header_widget.dart';
import 'widgets/task_card_widget.dart';
import 'widgets/add_task_dialog_widget.dart';

class ChecklistView extends StatefulWidget {
  final PatientModel patient;

  const ChecklistView({super.key, required this.patient});

  @override
  State<ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<ChecklistView> {
  bool _isPendingTab = true;

  // TODO: replace with real API data
  final List<ChecklistTaskModel> _tasks = [
    ChecklistTaskModel(
      id: '1',
      title: 'Fasting Blood Sugar Test',
      description: 'Schedule lab work for comprehensive metabolic panel',
      dueDate: DateTime(2026, 1, 28),
      priority: TaskPriority.high,
      category: TaskCategory.test,
      status: TaskStatus.pending,
    ),
    ChecklistTaskModel(
      id: '2',
      title: 'Follow-up Appointment',
      description: 'Review blood pressure medication effectiveness',
      dueDate: DateTime(2026, 2, 5),
      priority: TaskPriority.medium,
      category: TaskCategory.appointment,
      status: TaskStatus.pending,
    ),
    ChecklistTaskModel(
      id: '3',
      title: 'ECG Test',
      description: 'Annual heart health screening',
      dueDate: DateTime(2026, 2, 15),
      priority: TaskPriority.medium,
      category: TaskCategory.test,
      status: TaskStatus.pending,
    ),
    ChecklistTaskModel(
      id: '4',
      title: 'Medication Review',
      description: 'Review current medications and adjust dosages',
      dueDate: DateTime(2026, 1, 27),
      priority: TaskPriority.high,
      category: TaskCategory.medication,
      status: TaskStatus.pending,
    ),
    ChecklistTaskModel(
      id: '5',
      title: 'Diet Consultation',
      description: 'Refer to nutritionist for meal planning',
      dueDate: DateTime(2026, 1, 20),
      priority: TaskPriority.low,
      category: TaskCategory.appointment,
      status: TaskStatus.completed,
    ),
    ChecklistTaskModel(
      id: '6',
      title: 'Blood Pressure Monitoring',
      description: 'Check daily readings log',
      dueDate: DateTime(2026, 1, 15),
      priority: TaskPriority.high,
      category: TaskCategory.followUp,
      status: TaskStatus.completed,
    ),
  ];

  List<ChecklistTaskModel> get _pendingTasks =>
      _tasks.where((t) => t.status == TaskStatus.pending).toList();

  List<ChecklistTaskModel> get _completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.completed).toList();

  void _toggleTask(ChecklistTaskModel task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = ChecklistTaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          priority: task.priority,
          category: task.category,
          status: task.status == TaskStatus.pending
              ? TaskStatus.completed
              : TaskStatus.pending,
        );
      }
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddTaskDialogWidget(
        onAdd: (task) => setState(() => _tasks.add(task)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _isPendingTab ? _pendingTasks : _completedTasks;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Patient Checklist',
                    style: GoogleFonts.archivo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    // Checklist header
                    ChecklistHeaderWidget(
                      patientName: widget.patient.name,
                      completedCount: _completedTasks.length,
                      totalCount: _tasks.length,
                    ),

                    const SizedBox(height: 16),

                    // ── Tabs ──
                    Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            label: 'Pending (${_pendingTasks.length})',
                            isActive: _isPendingTab,
                            onTap: () =>
                                setState(() => _isPendingTab = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TabButton(
                            label:
                                'Completed (${_completedTasks.length})',
                            isActive: !_isPendingTab,
                            onTap: () =>
                                setState(() => _isPendingTab = false),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Add Task button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Add New Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Task list ──
                    displayList.isEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No ${_isPendingTab ? 'pending' : 'completed'} tasks',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = displayList[index];
                              return TaskCardWidget(
                                task: task,
                                onToggle: () => _toggleTask(task),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}