import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/nurse_model.dart';
import '../cubit/nurse_cubit.dart';
import '../cubit/nurse_state.dart';
import 'widgets/nurse_search_bar_widget.dart';
import 'widgets/nurse_filter_chip_widget.dart';
import 'widgets/nurse_list_widget.dart';

class RequestNurseView extends StatefulWidget {
  const RequestNurseView({super.key});

  @override
  State<RequestNurseView> createState() => _RequestNurseViewState();
}

class _RequestNurseViewState extends State<RequestNurseView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String? _selectedNurseId;

  final List<String> _filters = [
    'All',
    'General Care',
    'Pediatric',
    'ICU',
    'Post-Surgery',
  ];

  List<NurseModel> _filtered(List<NurseModel> all) {
    return all.where((nurse) {
      final matchesSearch =
          _searchController.text.isEmpty ||
          nurse.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          nurse.specialty.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      final matchesFilter =
          _selectedFilter == 'All' ||
          nurse.specialty.toLowerCase().contains(_selectedFilter.toLowerCase());
      return matchesSearch && matchesFilter;
    }).toList();
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
      create: (_) => NurseCubit()..fetchNurses(),
      child: BlocBuilder<NurseCubit, NurseState>(
        builder: (context, state) {
          final allNurses =
              state is NurseLoaded ? state.nurses : <NurseModel>[];
          final filtered = _filtered(allNurses);

          final NurseModel? selectedNurse =
              filtered.where((n) => n.id == _selectedNurseId).isNotEmpty
                  ? filtered.firstWhere((n) => n.id == _selectedNurseId)
                  : null;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────
                  Container(
                    color: colorScheme.primary,
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NurseSearchBarWidget(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        NurseFilterChipWidget(
                          filters: _filters,
                          selected: _selectedFilter,
                          onSelected:
                              (val) => setState(() => _selectedFilter = val),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  // ── Section Header ───────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Nurses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                        if (state is NurseLoaded)
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
                              '${filtered.length} nurses',
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

                  // ── Body ────────────────────────────────
                  Expanded(
                    child: switch (state) {
                      NurseLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      NurseError(message: final msg) => Center(
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
                              msg,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed:
                                  () =>
                                      context.read<NurseCubit>().fetchNurses(),
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
                        child: NurseListWidget(
                          nurses: filtered,
                          selectedNurseId: _selectedNurseId,
                          onNurseSelected:
                              (nurse) =>
                                  setState(() => _selectedNurseId = nurse.id),
                        ),
                      ),
                    },
                  ),

                  // ── Continue Button ──────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                    color: colorScheme.primary,
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            selectedNurse == null
                                ? null
                                : () => context.push(
                                  '/nurseRequestDetails',
                                  extra: selectedNurse,
                                ),
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
