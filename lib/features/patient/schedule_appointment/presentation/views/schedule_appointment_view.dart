import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';
import 'widgets/appointment_type_card_widget.dart';
import 'widgets/date_picker_widget.dart';
import 'widgets/time_section_widget.dart';
import 'widgets/appointment_summary_strip_widget.dart';

class ScheduleAppointmentView extends StatefulWidget {
  final BookAppointmentModel doctor;
  const ScheduleAppointmentView({super.key, required this.doctor});

  @override
  State<ScheduleAppointmentView> createState() =>
      _ScheduleAppointmentViewState();
}

class _ScheduleAppointmentViewState extends State<ScheduleAppointmentView> {
  String _appointmentType = 'Video Call';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  List<DateTime> get _dates =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  // TODO: replace with real API booked times
  final List<String> _bookedTimes = ['10:30 AM', '01:00 PM', '04:30 PM'];

  final Map<String, List<String>> _timeSlots = {
    'Morning': [
      '09:00 AM', '09:30 AM', '10:00 AM',
      '10:30 AM', '11:00 AM', '11:30 AM',
    ],
    'Afternoon': [
      '12:00 PM', '12:30 PM', '01:00 PM',
      '01:30 PM', '02:00 PM', '02:30 PM',
    ],
    'Evening': [
      '03:00 PM', '03:30 PM', '04:00 PM',
      '04:30 PM', '05:00 PM', '05:30 PM',
    ],
  };

  String get _formattedDate =>
      DateFormat('EEE, d MMM').format(_selectedDate);

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [

            // Header
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
                    'Schedule Appointment',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Doctor summary card
                    _DoctorSummaryCard(doctor: widget.doctor),
                    const SizedBox(height: 20),

                    // Appointment type
                    _SectionLabel(label: 'Appointment Type'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: AppointmentTypeCardWidget(
                            title: 'Video Call',
                            subtitle: 'Online consultation',
                            icon: Icons.videocam_rounded,
                            isActive: _appointmentType == 'Video Call',
                            onTap: () => setState(
                                () => _appointmentType = 'Video Call'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppointmentTypeCardWidget(
                            title: 'In-Person',
                            subtitle: 'Clinic visit',
                            icon: Icons.location_on_rounded,
                            isActive: _appointmentType == 'In-Person',
                            onTap: () => setState(
                                () => _appointmentType = 'In-Person'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Select date
                    _SectionLabel(label: 'Select Date'),
                    const SizedBox(height: 10),
                    DatePickerWidget(
                      dates: _dates,
                      selectedDate: _selectedDate,
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                    ),
                    const SizedBox(height: 20),

                    // Available times
                    _SectionLabel(label: 'Available Times'),
                    const SizedBox(height: 10),
                    ..._timeSlots.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TimeSectionWidget(
                          period: entry.key,
                          times: entry.value,
                          bookedTimes: _bookedTimes,
                          selectedTime: _selectedTime,
                          onTimeSelected: (time) =>
                              setState(() => _selectedTime = time),
                        ),
                      ),
                    ),

                    // Summary strip — shows only after time is selected
                    if (_selectedTime != null) ...[
                      AppointmentSummaryStripWidget(
                        date: _formattedDate,
                        time: _selectedTime!,
                        type: _appointmentType,
                        fee: 'SAR ${widget.doctor.consultationFee.toInt()}',
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Notes
                    _SectionLabel(label: 'Additional Notes', optional: true),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              Theme.of(context).colorScheme.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              Theme.of(context).colorScheme.inverseSurface,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Describe your symptoms or reason for visit...',
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Book button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _selectedTime == null
                      ? null
                      : () {
                          // TODO: connect your booking API here
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    disabledBackgroundColor:
                        Theme.of(context).colorScheme.outlineVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Book Appointment',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 16,
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
  }
}

// ── Doctor Summary Card ──
class _DoctorSummaryCard extends StatelessWidget {
  final BookAppointmentModel doctor;
  const _DoctorSummaryCard({required this.doctor});

  List<Color> _avatarGradient() {
    final gradients = [
      [const Color(0xFF0D9488), const Color(0xFF14B8A6)],
      [const Color(0xFF3B82F6), const Color(0xFF6366F1)],
      [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
      [const Color(0xFFF59E0B), const Color(0xFFF97316)],
      [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
    ];
    final index = doctor.initials.codeUnitAt(0) % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _avatarGradient();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                doctor.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 3),
                    Text(
                      '${doctor.rating} (${doctor.reviewCount})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3, height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${doctor.yearsExperience} yrs exp',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Fee',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'SAR ${doctor.consultationFee.toInt()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Section Label ──
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool optional;
  const _SectionLabel({required this.label, this.optional = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          Text(
            '(Optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ],
      ],
    );
  }
}