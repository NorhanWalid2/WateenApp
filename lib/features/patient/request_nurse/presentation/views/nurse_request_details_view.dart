import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/nurse_model.dart';
import '../cubit/nurse_cubit.dart';
import '../cubit/nurse_state.dart';
import 'widgets/nurse_profile_card_widget.dart';

class NurseRequestDetailsView extends StatefulWidget {
  final NurseModel nurse;
  const NurseRequestDetailsView({super.key, required this.nurse});

  @override
  State<NurseRequestDetailsView> createState() =>
      _NurseRequestDetailsViewState();
}

class _NurseRequestDetailsViewState extends State<NurseRequestDetailsView> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final colorScheme = Theme.of(context).colorScheme;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: colorScheme.copyWith(primary: colorScheme.secondary),
            ),
            child: child!,
          ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: colorScheme.copyWith(primary: colorScheme.secondary),
            ),
            child: child!,
          ),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}   $hour:$minute $ampm';
  }

  void _submit(BuildContext context) {
    if (_addressController.text.trim().isEmpty) {
      _showError(context, 'Please enter your service address');
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError(context, 'Please enter a service description');
      return;
    }
    if (_selectedDateTime == null) {
      _showError(context, 'Please select a requested time');
      return;
    }

    context.read<NurseCubit>().bookNurse(
      nurseId: widget.nurse.id,
      address: _addressController.text.trim(),
      serviceDescription: _descriptionController.text.trim(),
      requestedTime: _selectedDateTime!,
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => NurseCubit(),
      child: BlocConsumer<NurseCubit, NurseState>(
        listener: (context, state) {
          if (state is NurseBookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request sent successfully!'),
                backgroundColor: Color(0xFF16A34A),
                duration: Duration(seconds: 3),
              ),
            );
            context.pop();
            context.pop();
          } else if (state is NurseBookingError) {
            _showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is NurseBookingLoading;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // ── Header ─────────────────────────────────────────
                  Container(
                    color: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: colorScheme.inverseSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Request Details',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Scrollable Body ────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nurse card
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: NurseProfileCardWidget(nurse: widget.nurse),
                          ),

                          // Form card — all fields grouped
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Address
                                _FormField(
                                  icon: Icons.location_on_rounded,
                                  label: 'Service Address',
                                  child: TextField(
                                    controller: _addressController,
                                    maxLines: 2,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.inverseSurface,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your full address...',
                                      hintStyle: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      focusedBorder: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                        left: 5,
                                        top: 5,
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),

                                // Description
                                _FormField(
                                  icon: Icons.medical_services_rounded,
                                  label: 'Service Description',
                                  child: TextField(
                                    controller: _descriptionController,
                                    maxLines: 3,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.inverseSurface,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Describe the care you need (e.g. wound care, medication)...',
                                      hintStyle: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      focusedBorder: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                        left: 5,
                                        top: 5,
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),

                                // Date & Time
                                _FormField(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'Requested Time',
                                  onTap: _pickDateTime,
                                  trailing: Icon(
                                    Icons.chevron_right_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  child: Text(
                                    _selectedDateTime != null
                                        ? _formatDateTime(_selectedDateTime!)
                                        : 'Select date and time...',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color:
                                          _selectedDateTime != null
                                              ? colorScheme.inverseSurface
                                              : colorScheme.onSurfaceVariant,
                                      fontWeight:
                                          _selectedDateTime != null
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // ── Confirm Button ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          disabledBackgroundColor: colorScheme.outline
                              .withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Confirm Request',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
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

// ── Reusable form field row ────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _FormField({
    required this.icon,
    required this.label,
    required this.child,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.secondary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}