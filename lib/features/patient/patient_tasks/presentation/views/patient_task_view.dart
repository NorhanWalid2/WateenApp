import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/patient/patient_tasks/data/models/patient_task_model.dart';
import 'package:wateen_app/features/patient/patient_tasks/presentation/cubit/patient_task_cubit.dart';
import 'package:wateen_app/features/patient/patient_tasks/presentation/cubit/patient_task_state.dart';

 
class PatientTasksView extends StatefulWidget {
  const PatientTasksView({super.key});
 
  @override
  State<PatientTasksView> createState() => _PatientTasksViewState();
}
 
class _PatientTasksViewState extends State<PatientTasksView> {
  bool _isPendingTab = true;
  late final PatientTaskCubit _cubit;
 
  @override
  void initState() {
    super.initState();
    _cubit = PatientTaskCubit()..fetchTasks(isCompleted: false);
  }
 
  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
 
  void _switchTab(bool pending) {
    setState(() => _isPendingTab = pending);
    _cubit.fetchTasks(isCompleted: !pending);
  }
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);
 
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<PatientTaskCubit, PatientTaskState>(
        listener: (context, state) {
          if (state is PatientTaskActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is PatientTaskError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          final tasks = state is PatientTaskLoaded
              ? state.tasks
              : <PatientTaskModel>[];
          final isLoading = state is PatientTaskLoading;
 
          return Scaffold(
            backgroundColor: colorScheme.background,
            body: SafeArea(
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────
                  Container(
                    color: colorScheme.primary,
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: colorScheme.inverseSurface),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('My Care Plan',
                                style: GoogleFonts.archivo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.inverseSurface,
                                )),
                            const Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  _cubit.fetchTasks(isCompleted: !_isPendingTab),
                              child: Icon(Icons.refresh_rounded,
                                  color: colorScheme.inverseSurface),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _TabBtn(
                                label: 'Pending',
                                isActive: _isPendingTab,
                                onTap: () => _switchTab(true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _TabBtn(
                                label: 'Completed',
                                isActive: !_isPendingTab,
                                onTap: () => _switchTab(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
 
                  // ── Body ──────────────────────────────────────────
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : tasks.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.checklist_rounded,
                                        size: 56,
                                        color: colorScheme.outlineVariant),
                                    const SizedBox(height: 12),
                                    Text(
                                      _isPendingTab
                                          ? 'No pending tasks'
                                          : 'No completed tasks',
                                      style: TextStyle(
                                          color: colorScheme.outlineVariant),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () => _cubit.fetchTasks(
                                    isCompleted: !_isPendingTab),
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(20),
                                  itemCount: tasks.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    return _TaskCard(
                                      task: task,
                                      onComplete: _isPendingTab
                                          ? () => _cubit.completeTask(task.id)
                                          : null,
                                    );
                                  },
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
 
class _TaskCard extends StatelessWidget {
  final PatientTaskModel task;
  final VoidCallback? onComplete;
  const _TaskCard({required this.task, this.onComplete});
 
  Color _priorityColor(BuildContext context) {
    switch (task.priority.toLowerCase()) {
      case 'high': return Theme.of(context).colorScheme.secondary;
      case 'low': return const Color(0xFF16A34A);
      default: return const Color(0xFFF59E0B);
    }
  }
 
  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priorityColor = _priorityColor(context);
 
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: task.isOverdue
              ? colorScheme.secondary.withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Checkbox / complete button
          GestureDetector(
            onTap: onComplete,
            child: Container(
              width: 26, height: 26,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted
                    ? const Color(0xFF16A34A)
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFF16A34A)
                      : onComplete != null
                          ? colorScheme.secondary
                          : colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
          ),
 
          const SizedBox(width: 12),
 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(task.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.inverseSurface,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          )),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: priorityColor.withOpacity(0.3)),
                      ),
                      child: Text(task.priority,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: priorityColor)),
                    ),
                  ],
                ),
 
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(task.description,
                      style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.outlineVariant)),
                ],
 
                const SizedBox(height: 8),
 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 13,
                            color: task.isOverdue
                                ? colorScheme.secondary
                                : colorScheme.outlineVariant),
                        const SizedBox(width: 4),
                        Text(
                          task.isOverdue
                              ? '${_formatDate(task.dueDate)} (Overdue)'
                              : _formatDate(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: task.isOverdue
                                ? colorScheme.secondary
                                : colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                    Text(task.category,
                        style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.outlineVariant)),
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
 
class _TabBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.isActive, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFDC2626);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? primaryRed : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isActive
                  ? primaryRed
                  : Theme.of(context).colorScheme.outlineVariant),
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