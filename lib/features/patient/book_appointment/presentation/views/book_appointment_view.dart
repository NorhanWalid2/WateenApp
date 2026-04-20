import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_state.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_cubit.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/chat_view.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/specialty_filter_widget.dart';
import 'widgets/doctors_list_widget.dart';

class BookAppointmentView extends StatefulWidget {
  const BookAppointmentView({super.key});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';
  String? _selectedDoctorId;

  List<BookAppointmentModel> _filtered(List<BookAppointmentModel> all) {
    return all.where((d) {
      final matchSearch =
          _searchController.text.isEmpty ||
          d.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          d.specialty.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      final matchSpecialty =
          _selectedSpecialty == 'All' || d.specialty == _selectedSpecialty;
      return matchSearch && matchSpecialty;
    }).toList();
  }

  List<String> _buildSpecialties(List<BookAppointmentModel> doctors) {
    final specialties =
        doctors.map((d) => d.specialty).toSet().toList()..sort();
    return ['All', ...specialties];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => BookAppointmentCubit()..fetchDoctors(),
      child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
        builder: (context, state) {
          final allDoctors =
              state is BookAppointmentLoaded
                  ? state.doctors
                  : <BookAppointmentModel>[];
          final filtered = _filtered(allDoctors);
          final specialties = _buildSpecialties(allDoctors);

          final selectedDoctor =
              filtered.where((d) => d.id == _selectedDoctorId).isNotEmpty
                  ? filtered.firstWhere((d) => d.id == _selectedDoctorId)
                  : null;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────
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
                          onSelected:
                              (val) => setState(() => _selectedSpecialty = val),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  // ── Section Header ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Doctors',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                        if (state is BookAppointmentLoaded)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${filtered.length} doctors',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Body ──────────────────────────────────────────
                  Expanded(
                    child: switch (state) {
                      BookAppointmentLoading() => ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, __) => const ShimmerNurseCardWidget(),
                      ),
                      BookAppointmentError(:final message) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              size: 48,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed:
                                  () =>
                                      context
                                          .read<BookAppointmentCubit>()
                                          .fetchDoctors(),
                              child: Text(
                                'Retry',
                                style: TextStyle(color: colorScheme.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _ => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: DoctorsListWidget(
                          doctors: filtered,
                          selectedDoctorId: _selectedDoctorId,
                          onDoctorSelected:
                              (d) => setState(() => _selectedDoctorId = d.id),
                        ),
                      ),
                    },
                  ),

                  // ── Continue Button ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                    color: colorScheme.primary,
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            selectedDoctor == null
                                ? null
                                : () {
                                  final conversation = ConversationModel(
                                    otherUserId: selectedDoctor.id,
                                    doctorName: selectedDoctor.name,
                                    specialty: selectedDoctor.specialty,
                                    lastMessage: '',
                                    time: '',
                                    unreadCount: 0,
                                    initials: selectedDoctor.initials,
                                    color: Colors.blue,
                                    isOnline: false,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => BlocProvider.value(
                                            value:
                                                ChatCubit(), // singleton — same instance
                                            child: ChatView(
                                              conversation: conversation,
                                            ),
                                          ),
                                    ),
                                  ).then(
                                    (_) => ChatCubit().loadConversations(),
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          disabledBackgroundColor: colorScheme.outlineVariant,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
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
        },
      ),
    );
  }
}
