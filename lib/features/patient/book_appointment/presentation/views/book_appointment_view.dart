import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/calendly_model.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_state.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/specialty_filter_widget.dart';

class BookAppointmentView extends StatefulWidget {
  const BookAppointmentView({super.key});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';

  List<BookAppointmentModel> _filtered(List<BookAppointmentModel> all) {
    return all.where((d) {
      final matchSearch = _searchController.text.isEmpty ||
          d.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          d.specialty.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchSpecialty =
          _selectedSpecialty == 'All' || d.specialty == _selectedSpecialty;
      return matchSearch && matchSpecialty;
    }).toList();
  }

  List<String> _buildSpecialties(List<BookAppointmentModel> doctors) {
    final specialties = doctors.map((d) => d.specialty).toSet().toList()..sort();
    return ['All', ...specialties];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDoctorProfile(BuildContext context, BookAppointmentModel doctor) {
    final cubit = context.read<BookAppointmentCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: DoctorProfileSheet(doctor: doctor),
      ),
    );
    cubit.fetchEventTypes(doctorId: doctor.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => BookAppointmentCubit()..fetchDoctors(),
      child: Builder(
        builder: (context) => BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          buildWhen: (_, state) =>
              state is BookAppointmentLoading ||
              state is BookAppointmentLoaded ||
              state is BookAppointmentError,
          builder: (context, state) {
            final allDoctors = state is BookAppointmentLoaded
                ? state.doctors
                : <BookAppointmentModel>[];
            final filtered = _filtered(allDoctors);
            final specialties = _buildSpecialties(allDoctors);

            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: SafeArea(
                child: Column(
                  children: [
                    // ── Header ───────────────────────────────
                    Container(
                      color: colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: colorScheme.inverseSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Book Appointment',
                                style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 22,
                                  color: colorScheme.inverseSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SearchBarWidget(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 14),
                          SpecialtyFilterWidget(
                            specialties: specialties,
                            selected: _selectedSpecialty,
                            onSelected: (val) =>
                                setState(() => _selectedSpecialty = val),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),

                    // ── Section header ────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Available Doctors',
                              style: textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          if (state is BookAppointmentLoaded)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('${filtered.length} doctors',
                                  style: TextStyle(
                                      color: colorScheme.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                    ),

                    // ── Body ─────────────────────────────────
                    Expanded(
                      child: state is BookAppointmentLoading
                          ? ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: 4,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, __) => const ShimmerNurseCardWidget(),
                            )
                          : state is BookAppointmentError
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.wifi_off_rounded,
                                          size: 48,
                                          color: colorScheme.onSurfaceVariant),
                                      const SizedBox(height: 12),
                                      Text(state.message),
                                      const SizedBox(height: 16),
                                      TextButton.icon(
                                        onPressed: () => context
                                            .read<BookAppointmentCubit>()
                                            .fetchDoctors(),
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: const Text('Retry'),
                                        style: TextButton.styleFrom(
                                            foregroundColor:
                                                colorScheme.secondary),
                                      ),
                                    ],
                                  ),
                                )
                              : filtered.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.search_off_rounded,
                                              size: 48,
                                              color: colorScheme.onSurfaceVariant),
                                          const SizedBox(height: 12),
                                          Text('No doctors found',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant)),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 8),
                                      itemCount: filtered.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (_, i) => DoctorCardWidget(
                                        doctor: filtered[i],
                                        onTap: () => _showDoctorProfile(
                                            context, filtered[i]),
                                      ),
                                    ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Doctor Card ───────────────────────────────────────────────────────────────
class DoctorCardWidget extends StatelessWidget {
  final BookAppointmentModel doctor;
  final VoidCallback onTap;

  const DoctorCardWidget({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar ─────────────────────────────────────
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.secondary.withOpacity(0.1),
              backgroundImage: (doctor.profilePicture != null &&
                      doctor.profilePicture!.startsWith('http'))
                  ? NetworkImage(doctor.profilePicture!)
                  : null,
              child: (doctor.profilePicture == null ||
                      !doctor.profilePicture!.startsWith('http'))
                  ? Text(
                      doctor.initials,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // ── Info ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          doctor.specialty,
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.work_outline_rounded,
                          size: 12, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('${doctor.yearsExperience} yrs exp',
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_month_outlined,
                          size: 12, color: colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text('Book Now',
                          style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ── Doctor Profile Sheet ──────────────────────────────────────────────────────
class DoctorProfileSheet extends StatelessWidget {
  final BookAppointmentModel doctor;

  const DoctorProfileSheet({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ─────────────────────────────────────────
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Doctor header ───────────────────────────────────
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: colorScheme.secondary.withOpacity(0.1),
                backgroundImage: (doctor.profilePicture != null &&
                        doctor.profilePicture!.startsWith('http'))
                    ? NetworkImage(doctor.profilePicture!)
                    : null,
                child: (doctor.profilePicture == null ||
                        !doctor.profilePicture!.startsWith('http'))
                    ? Text(doctor.initials,
                        style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w700))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(doctor.specialty,
                          style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Bio ──────────────────────────────────────────────
          if (doctor.bio != null && doctor.bio!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(doctor.bio!,
                  style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant, height: 1.5)),
            ),
            const SizedBox(height: 14),
          ],

          // ── Stats row ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  icon: Icons.work_outline_rounded,
                  label: 'Experience',
                  value: '${doctor.yearsExperience} years',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatChip(
                  icon: Icons.medical_services_outlined,
                  label: 'Specialty',
                  value: doctor.specialty,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),

          // ── Education ────────────────────────────────────────
          if (doctor.education != null && doctor.education!.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_rounded,
                      color: colorScheme.secondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Education',
                            style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(doctor.education!,
                            style: textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ── Certification ────────────────────────────────────
          if (doctor.certification != null && doctor.certification!.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_rounded,
                      color: colorScheme.secondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Certification',
                            style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(doctor.certification!,
                            style: textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
          Divider(color: colorScheme.outline.withOpacity(0.2)),
          const SizedBox(height: 16),

          // ── Calendly event types ────────────────────────────
          BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
            builder: (context, state) {
              if (state is CalendlyLoading) {
                return Column(
                  children: [
                    CircularProgressIndicator(color: colorScheme.secondary,
                        strokeWidth: 2),
                    const SizedBox(height: 12),
                    Text('Loading booking options...',
                        style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant)),
                  ],
                );
              }

              if (state is CalendlyNotSetup) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: colorScheme.outline.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: colorScheme.onSurfaceVariant, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This doctor hasn\'t set up online booking yet. Please contact the clinic directly.',
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is CalendlyLoaded &&
                  state.doctorId == doctor.id) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Sessions',
                        style: textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ...state.eventTypes.map((event) => GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(event.schedulingUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                      size: 20),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(event.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14)),
                                      Text(
                                          '${event.durationMinutes} minutes session',
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.8),
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.open_in_new_rounded,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 18),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              }

              // Default — show book button
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context
                      .read<BookAppointmentCubit>()
                      .fetchEventTypes(doctorId: doctor.id),
                  icon: const Icon(Icons.calendar_month_rounded,
                      color: Colors.white, size: 18),
                  label: const Text('Check Available Slots',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
        ),  // Column
      ),    // SingleChildScrollView
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text(value,
                    style: textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}