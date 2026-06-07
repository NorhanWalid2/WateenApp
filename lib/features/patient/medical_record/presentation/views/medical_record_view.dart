import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/patient/medical_record/data/models/medical_record_model.dart';
import 'package:wateen_app/features/patient/medical_record/presentation/cubit/medical_record_cubit.dart';
import 'package:wateen_app/features/patient/medical_record/presentation/cubit/medical_record_state.dart';
 

class MedicalRecordsView extends StatefulWidget {
  const MedicalRecordsView({super.key});

  @override
  State<MedicalRecordsView> createState() => _MedicalRecordsViewState();
}

class _MedicalRecordsViewState extends State<MedicalRecordsView>
    with TickerProviderStateMixin {
  MedicalRecordType _selectedFilter = MedicalRecordType.all;
  late final MedicalRecordsCubit _cubit;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cubit = MedicalRecordsCubit()..fetchRecords();
    _fadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(
        parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _cubit.close();
    _fadeController.dispose();
    super.dispose();
  }

  void _switchFilter(MedicalRecordType type) {
    setState(() => _selectedFilter = type);
    _cubit.fetchRecords(filter: type);
    _fadeController.reset();
    _fadeController.forward();
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: _AddRecordSheet(),
      ),
    );
  }

  void _confirmDelete(BuildContext context, MedicalRecordModel record) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Delete "${record.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cubit.deleteRecord(record.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<MedicalRecordsCubit, MedicalRecordsState>(
        listener: (context, state) {
          if (state is MedicalRecordActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is MedicalRecordActionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          final records = state is MedicalRecordsLoaded
              ? state.records : <MedicalRecordModel>[];
          final isLoading = state is MedicalRecordsLoading;

          return Scaffold(
            backgroundColor: colorScheme.background,
            body: SafeArea(
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────
                  Container(
                    decoration: const BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(28)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text('Medical Records',
                                style: GoogleFonts.archivo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                            const Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  _cubit.fetchRecords(filter: _selectedFilter),
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.refresh_rounded,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Stats
                        Row(
                          children: [
                            _StatPill(
                              label: records.length.toString(),
                              sublabel: 'Total Records',
                              icon: Icons.folder_outlined,
                            ),
                            const SizedBox(width: 10),
                            _StatPill(
                              label: records
                                  .where((r) => r.addedByPatient)
                                  .length
                                  .toString(),
                              sublabel: 'Self Added',
                              icon: Icons.person_outline_rounded,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: MedicalRecordType.values
                                .map((type) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: _FilterChip(
                                        label: _filterLabel(type),
                                        isSelected: _selectedFilter == type,
                                        onTap: () => _switchFilter(type),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Body ─────────────────────────────────────
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state is MedicalRecordsError
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error_outline_rounded,
                                        size: 48,
                                        color: colorScheme.error),
                                    const SizedBox(height: 12),
                                    Text(state.message),
                                    TextButton(
                                      onPressed: () => _cubit.fetchRecords(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : records.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.folder_open_rounded,
                                            size: 56,
                                            color: colorScheme.outlineVariant),
                                        const SizedBox(height: 12),
                                        Text('No records found',
                                            style: TextStyle(
                                                color: colorScheme.outlineVariant)),
                                      ],
                                    ),
                                  )
                                : FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: RefreshIndicator(
                                      onRefresh: () => _cubit.fetchRecords(
                                          filter: _selectedFilter),
                                      child: ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 100),
                                        itemCount: records.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (_, i) => _RecordCard(
                                          record: records[i],
                                          index: i,
                                          onDelete: () => _confirmDelete(
                                              context, records[i]),
                                        ),
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),

            floatingActionButton: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: FloatingActionButton.extended(
                onPressed: _showAddSheet,
                backgroundColor: primaryRed,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 22),
                label: Text('Add Medical History',
                    style: GoogleFonts.archivo(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  String _filterLabel(MedicalRecordType type) {
    switch (type) {
      case MedicalRecordType.all: return 'All';
      case MedicalRecordType.labResult: return 'Lab result';
      case MedicalRecordType.doctorNote: return 'Doctor note';
      case MedicalRecordType.history: return 'History';
      case MedicalRecordType.imaging: return 'Imaging';
    }
  }
}

// ── Record Card ───────────────────────────────────────────────────────────────

class _RecordCard extends StatelessWidget {
  final MedicalRecordModel record;
  final int index;
  final VoidCallback onDelete;

  const _RecordCard({
    required this.record,
    required this.index,
    required this.onDelete,
  });

  Color _typeColor() {
    switch (record.type) {
      case MedicalRecordType.labResult: return const Color(0xFF3B82F6);
      case MedicalRecordType.doctorNote: return const Color(0xFF10B981);
      case MedicalRecordType.history: return const Color(0xFFF59E0B);
      case MedicalRecordType.imaging: return const Color(0xFF8B5CF6);
      case MedicalRecordType.all: return Colors.grey;
    }
  }

  IconData _typeIcon() {
    switch (record.type) {
      case MedicalRecordType.labResult: return Icons.science_outlined;
      case MedicalRecordType.doctorNote: return Icons.description_outlined;
      case MedicalRecordType.history: return Icons.monitor_heart_outlined;
      case MedicalRecordType.imaging: return Icons.image_outlined;
      case MedicalRecordType.all: return Icons.folder_outlined;
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
    final color = _typeColor();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)), child: child),
      ),
      child: Dismissible(
        key: Key(record.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete_outline_rounded,
              color: Colors.red, size: 24),
        ),
        confirmDismiss: (_) async {
          onDelete();
          return false; // cubit handles list update
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_typeIcon(), color: color, size: 22),
              ),

              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.inverseSurface,
                        )),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(record.typeLabel,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record.addedByPatient
                              ? 'Added by patient'
                              : record.doctorName!,
                          style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.outlineVariant),
                        ),
                        Text(_formatDate(record.date),
                            style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.outlineVariant)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete_outline_rounded,
                    color: colorScheme.error, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Add Record Sheet ──────────────────────────────────────────────────────────

class _AddRecordSheet extends StatefulWidget {
  @override
  State<_AddRecordSheet> createState() => _AddRecordSheetState();
}

class _AddRecordSheetState extends State<_AddRecordSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  MedicalRecordType _type = MedicalRecordType.history;
  DateTime _date = DateTime.now();
  File? _pickedFile;
  bool _isSubmitting = false;

  final _types = [
    MedicalRecordType.labResult,
    MedicalRecordType.doctorNote,
    MedicalRecordType.history,
    MedicalRecordType.imaging,
  ];

  String _typeLabel(MedicalRecordType t) {
    switch (t) {
      case MedicalRecordType.labResult: return 'Lab result';
      case MedicalRecordType.doctorNote: return 'Doctor note';
      case MedicalRecordType.history: return 'Medical history';
      case MedicalRecordType.imaging: return 'Imaging';
      default: return '';
    }
  }

  Future<void> _pickFile() async {
    // Show source picker: camera or gallery
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Select File',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface,
                )),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: Color(0xFFDC2626)),
              title: const Text('Photo Library'),
              subtitle: const Text('JPG, PNG'),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 90,
                );
                if (file != null && mounted) {
                  setState(() => _pickedFile = File(file.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: Color(0xFFDC2626)),
              title: const Text('Camera'),
              subtitle: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final file = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 90,
                );
                if (file != null && mounted) {
                  setState(() => _pickedFile = File(file.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a title'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isSubmitting = true);

    await context.read<MedicalRecordsCubit>().addMyHistory(
      title: _titleCtrl.text.trim(),
      type: _type,
      date: _date,
      description: _descCtrl.text.trim(),
      file: _pickedFile,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),

            Text('Add Medical History',
                style: GoogleFonts.archivo(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.inverseSurface,
                )),

            const SizedBox(height: 20),

            _Label('Title *'),
            const SizedBox(height: 6),
            _Input(controller: _titleCtrl,
                hint: 'e.g., Blood glucose test'),

            const SizedBox(height: 14),

            _Label('Type'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _types.map((t) => GestureDetector(
                onTap: () => setState(() => _type = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _type == t ? primaryRed : colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _type == t
                          ? primaryRed
                          : colorScheme.outlineVariant,
                    ),
                  ),
                  child: Text(_typeLabel(t),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _type == t
                            ? Colors.white
                            : colorScheme.outlineVariant,
                      )),
                ),
              )).toList(),
            ),

            const SizedBox(height: 14),

            _Label('Date'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_date),
                        style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.inverseSurface)),
                    Icon(Icons.calendar_today_rounded,
                        size: 16, color: colorScheme.outlineVariant),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            _Label('Description (optional)'),
            const SizedBox(height: 6),
            _Input(
              controller: _descCtrl,
              hint: 'Add any notes...',
              maxLines: 3,
            ),

            const SizedBox(height: 14),

            // ℹ️ File upload coming soon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Colors.blue, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'File attachments will be supported in a future update.',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text('Save Record',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFFDC2626) : Colors.white,
            )),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  const _StatPill({required this.label, required this.sublabel, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              Text(sublabel,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.outlineVariant,
        ));
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _Input({required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 14, color: colorScheme.inverseSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colorScheme.outlineVariant, fontSize: 14),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}