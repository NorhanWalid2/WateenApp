// lib/features/patient/book_appointment/presentation/views/widgets/booking_sheet_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_state.dart';

class BookingSheetWidget extends StatefulWidget {
  final BookAppointmentModel doctor;

  const BookingSheetWidget({super.key, required this.doctor});

  @override
  State<BookingSheetWidget> createState() => _BookingSheetWidgetState();
}

class _BookingSheetWidgetState extends State<BookingSheetWidget> {
  CalendlySlot? _selectedSlot;
  String _appointmentType = 'InPerson';
  final TextEditingController _reasonController = TextEditingController();

  bool _isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  void initState() {
    super.initState();
    // Fetch slots when sheet opens
    context.read<BookAppointmentCubit>().fetchSlots(widget.doctor.id);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _book() {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter reason for visit')),
      );
      return;
    }

    context.read<BookAppointmentCubit>().bookAppointment(
      doctorId: widget.doctor.id,
      scheduledDate: _selectedSlot!.startTime,
      reason: _reasonController.text.trim(),
      appointmentType: _appointmentType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state is BookAppointmentSuccess) {
          Navigator.pop(context, true); // return true = booked
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Appointment booked successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is BookAppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Handle ──
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colorScheme.secondary.withOpacity(0.15),
                      backgroundImage: _isValidUrl(widget.doctor.profilePicture)
                          ? NetworkImage(widget.doctor.profilePicture!)
                          : null,
                      child: !_isValidUrl(widget.doctor.profilePicture)
                          ? Text(
                              widget.doctor.initials,
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctor.name,
                            style: GoogleFonts.archivo(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.inverseSurface,
                            ),
                          ),
                          Text(
                            widget.doctor.specialty,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close_rounded,
                          color: colorScheme.outlineVariant),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Appointment Type ──
                      Text(
                        'Appointment Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.inverseSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _TypeChip(
                            label: 'In-person',
                            icon: Icons.local_hospital_outlined,
                            isSelected: _appointmentType == 'InPerson',
                            onTap: () =>
                                setState(() => _appointmentType = 'InPerson'),
                          ),
                          const SizedBox(width: 10),
                          _TypeChip(
                            label: 'Video Call',
                            icon: Icons.videocam_outlined,
                            isSelected: _appointmentType == 'VideoCall',
                            onTap: () =>
                                setState(() => _appointmentType = 'VideoCall'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Available Slots ──
                      Text(
                        'Available Slots',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.inverseSurface,
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (state is BookAppointmentSlotsLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (state is BookAppointmentSlotsLoaded &&
                          state.slots.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color: colorScheme.outlineVariant),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'No available slots. The doctor hasn\'t set up Calendly yet.',
                                  style: TextStyle(
                                    color: colorScheme.outlineVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (state is BookAppointmentSlotsLoaded)
                        _buildSlotsByDate(state.slots, colorScheme)
                      else
                        _buildSlotsByDate([], colorScheme),

                      const SizedBox(height: 24),

                      // ── Reason ──
                      Text(
                        'Reason for Visit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.inverseSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _reasonController,
                        maxLines: 3,
                        style: TextStyle(color: colorScheme.inverseSurface),
                        decoration: InputDecoration(
                          hintText: 'Describe your symptoms or reason...',
                          hintStyle:
                              TextStyle(color: colorScheme.outlineVariant),
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Book Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: state is BookAppointmentBooking
                              ? null
                              : _book,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary,
                            disabledBackgroundColor:
                                colorScheme.outlineVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: state is BookAppointmentBooking
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Confirm Booking',
                                  style: GoogleFonts.archivo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlotsByDate(List<CalendlySlot> slots, ColorScheme colorScheme) {
    // Group by date
    final Map<String, List<CalendlySlot>> byDate = {};
    for (final slot in slots) {
      byDate.putIfAbsent(slot.displayDate, () => []).add(slot);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: byDate.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.outlineVariant,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entry.value.map((slot) {
                final isSelected = _selectedSlot?.startTime == slot.startTime;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSlot = slot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.secondary
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.secondary
                            : colorScheme.outlineVariant.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      slot.displayTime,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.secondary
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.outlineVariant.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color:
                    isSelected ? Colors.white : colorScheme.outlineVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? Colors.white : colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}