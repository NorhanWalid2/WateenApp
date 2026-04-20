import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
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

  List<String> _buildFilters(List<NurseModel> nurses) {
    final specialties = nurses.map((n) => n.specialty).toSet().toList()..sort();
    return ['All', ...specialties];
  }

  List<NurseModel> _filteredNurses(List<NurseModel> all) {
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
          // ── Derive data from state ────────────────────────────────
          final List<NurseModel> allNurses =
              state is NurseLoaded ? state.nurses : [];
          final filters = _buildFilters(allNurses);
          final filtered = _filteredNurses(allNurses);

          // Reset filter if no longer valid
          if (!filters.contains(_selectedFilter)) {
            _selectedFilter = 'All';
          }

          final selectedNurse = allNurses.cast<NurseModel?>().firstWhere(
            (n) => n?.id == _selectedNurseId,
            orElse: () => null,
          );

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────
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
                              'Request Nurse',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 22,
                                color: colorScheme.inverseSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        NurseSearchBarWidget(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        if (state is NurseLoaded)
                          NurseFilterChipWidget(
                            filters: filters,
                            selected: _selectedFilter,
                            onSelected:
                                (val) => setState(() => _selectedFilter = val),
                          ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  // ── Section header ──────────────────────────────────
                  if (state is NurseLoaded)
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.12),
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

                  // ── Body ────────────────────────────────────────────
                  Expanded(
                    child: _buildBody(
                      context: context,
                      state: state,
                      filtered: filtered,
                      colorScheme: colorScheme,
                    ),
                  ),

                  // ── Continue button ─────────────────────────────────
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

  Widget _buildBody({
    required BuildContext context,
    required NurseState state,
    required List<NurseModel> filtered,
    required ColorScheme colorScheme,
  }) {
    if (state is NurseLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const ShimmerNurseCardWidget(),
      );
    }

    if (state is NurseError) {
      return Center(
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
              state.message,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => context.read<NurseCubit>().fetchNurses(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }

    if (state is NurseLoaded && filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'No nurses found',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (state is NurseLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: NurseListWidget(
          nurses: filtered,
          selectedNurseId: _selectedNurseId,
          onNurseSelected:
              (nurse) => setState(() => _selectedNurseId = nurse.id),
        ),
      );
    }

    return const SizedBox();
  }
}
