import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/checklist/presentation/cubit/checklist_state.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import 'package:wateen_app/features/doctor_role/checklist/data/models/checklist_model.dart';
import 'package:wateen_app/features/doctor_role/checklist/presentation/cubit/checklist_cubit.dart';
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
  late final ChecklistCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChecklistCubit(patientId: widget.patient.id)..fetchTasks();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddTaskDialogWidget(
        onAdd: (task) {
          _cubit.addTask(
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            priority: task.priority.name,
            category: task.category.name,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ChecklistCubit, ChecklistState>(
        listener: (context, state) {
          if (state is ChecklistActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is ChecklistError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          final pendingTasks =
              state is ChecklistLoaded ? state.pending : <ChecklistTaskModel>[];
          final completedTasks =
              state is ChecklistLoaded ? state.completed : <ChecklistTaskModel>[];
          final allTasks =
              state is ChecklistLoaded ? state.tasks : <ChecklistTaskModel>[];
          final displayList = _isPendingTab ? pendingTasks : completedTasks;
          final isLoading = state is ChecklistLoading;

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
                            child: Icon(Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: Theme.of(context).colorScheme.inverseSurface),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Patient Checklist',
                            style: GoogleFonts.archivo(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.inverseSurface,
                            )),
                        const Spacer(),
                        GestureDetector(
                          onTap: _cubit.fetchTasks,
                          child: Icon(Icons.refresh_rounded,
                              color: Theme.of(context).colorScheme.inverseSurface),
                        ),
                      ],
                    ),
                  ),

                  // ── Content ──
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Checklist header
                                ChecklistHeaderWidget(
                                  patientName: widget.patient.name,
                                  completedCount: completedTasks.length,
                                  totalCount: allTasks.length,
                                ),

                                const SizedBox(height: 16),

                                // ── Tabs ──
                                Row(
                                  children: [
                                    Expanded(
                                      child: _TabButton(
                                        label: 'Pending (${pendingTasks.length})',
                                        isActive: _isPendingTab,
                                        onTap: () =>
                                            setState(() => _isPendingTab = true),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _TabButton(
                                        label: 'Completed (${completedTasks.length})',
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
                                    label: const Text('Add New Task',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.secondary,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // ── Task list ──
                                displayList.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 40),
                                        child: Center(
                                          child: Text(
                                            'No ${_isPendingTab ? 'pending' : 'completed'} tasks',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant),
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
                                            onToggle: () {},
                                            // ✅ Doctor can delete tasks
                                            onDelete: () => _cubit.deleteTask(task.id),
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
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isActive, required this.onTap});

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
          child: Text(label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.outlineVariant,
              )),
        ),
      ),
    );
  }
}