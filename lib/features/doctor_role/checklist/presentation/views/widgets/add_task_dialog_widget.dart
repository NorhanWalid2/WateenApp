import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/checklist/data/models/checklist_model.dart';

class AddTaskDialogWidget extends StatefulWidget {
  final Function(ChecklistTaskModel) onAdd;

  const AddTaskDialogWidget({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTaskDialogWidget> createState() => _AddTaskDialogWidgetState();
}

class _AddTaskDialogWidgetState extends State<AddTaskDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _priority = 'Medium';
  String _category = 'Test';
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // ── Title ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Task Title ──
              _FieldLabel(label: 'Task Title'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Fasting Blood Sugar Test',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter task title' : null,
              ),

              const SizedBox(height: 14),

              // ── Description ──
              _FieldLabel(label: 'Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Provide details about the task',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter description' : null,
              ),

              const SizedBox(height: 14),

              // ── Due Date ──
              _FieldLabel(label: 'Due Date'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(_dueDate),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color:
                            Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Priority ──
              _FieldLabel(label: 'Priority'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _priority,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                    items: ChecklistTaskModel.priorityOptions
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _priority = val!),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Category ──
              _FieldLabel(label: 'Category'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                    items: ChecklistTaskModel.categoryOptions
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _category = val!),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Add Button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onAdd(
                        ChecklistTaskModel(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          dueDate: _dueDate,
                          priority: ChecklistTaskModel.priorityFromString(
                              _priority),
                          category: ChecklistTaskModel.categoryFromString(
                              _category),
                          status: TaskStatus.pending,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFE7000B)),
          ),
        ],
      ),
    );
  }
}