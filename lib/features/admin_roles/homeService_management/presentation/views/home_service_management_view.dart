import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/home_service_management_model.dart';
import 'widgets/home_service_card_widget.dart';

class HomeServiceManagementView extends StatefulWidget {
  const HomeServiceManagementView({super.key});

  @override
  State<HomeServiceManagementView> createState() =>
      _HomeServiceManagementViewState();
}

class _HomeServiceManagementViewState extends State<HomeServiceManagementView> {
  final TextEditingController _searchController = TextEditingController();
  HomeServiceStatus? _selectedStatus;

  // TODO: replace with real API data
  final List<HomeServiceManagementModel> _allProviders = [
    HomeServiceManagementModel(
      id: '1',
      name: 'Fatima Hassan',
      role: 'Home Healthcare Specialist',
      rating: 4.8,
      visitsCount: 432,
      location: 'Dubai, UAE',
      licenseNumber: 'DHA-67890',
      appliedDate: '2023-12-10',
      status: HomeServiceStatus.approved,
    ),
    HomeServiceManagementModel(
      id: '2',
      name: 'Noura Ahmed',
      role: 'Registered Nurse',
      rating: 4.7,
      visitsCount: 156,
      location: 'Abu Dhabi, UAE',
      licenseNumber: 'DHA-78901',
      appliedDate: '2024-01-20',
      status: HomeServiceStatus.pending,
    ),
    HomeServiceManagementModel(
      id: '3',
      name: 'Layla Mohammed',
      role: 'Physiotherapist',
      rating: 4.6,
      visitsCount: 89,
      location: 'Sharjah, UAE',
      licenseNumber: 'DHA-89012',
      appliedDate: '2024-01-22',
      status: HomeServiceStatus.pending,
    ),
    HomeServiceManagementModel(
      id: '4',
      name: 'Sara Abdullah',
      role: 'Pediatric Nurse',
      rating: 4.9,
      visitsCount: 210,
      location: 'Dubai, UAE',
      licenseNumber: 'DHA-90123',
      appliedDate: '2024-01-10',
      status: HomeServiceStatus.rejected,
    ),
  ];

  List<HomeServiceManagementModel> get _filteredProviders {
    return _allProviders.where((provider) {
      final matchesSearch =
          _searchController.text.isEmpty ||
          provider.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          provider.role.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      final matchesStatus =
          _selectedStatus == null || provider.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Wateen',
                      style: GoogleFonts.archivo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Home Service Management',
                      style: GoogleFonts.archivo(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review and manage home service providers',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Search ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.outlineVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search by name or role...',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Filter chips ──
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            isActive: _selectedStatus == null,
                            onTap: () => setState(() => _selectedStatus = null),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Pending',
                            isActive:
                                _selectedStatus == HomeServiceStatus.pending,
                            onTap:
                                () => setState(
                                  () =>
                                      _selectedStatus =
                                          HomeServiceStatus.pending,
                                ),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Approved',
                            isActive:
                                _selectedStatus == HomeServiceStatus.approved,
                            onTap:
                                () => setState(
                                  () =>
                                      _selectedStatus =
                                          HomeServiceStatus.approved,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Providers List ──
                    _filteredProviders.isEmpty
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No providers found',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredProviders.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final provider = _filteredProviders[index];
                            return HomeServiceCardWidget(
                              provider: provider,
                              onViewDetails: () {
                                // TODO: navigate to provider details
                              },
                              onApprove: () {
                                // TODO: connect approve API
                                setState(() {
                                  final i = _allProviders.indexWhere(
                                    (p) => p.id == provider.id,
                                  );
                                  _allProviders[i] = HomeServiceManagementModel(
                                    id: provider.id,
                                    name: provider.name,
                                    role: provider.role,
                                    rating: provider.rating,
                                    visitsCount: provider.visitsCount,
                                    location: provider.location,
                                    licenseNumber: provider.licenseNumber,
                                    appliedDate: provider.appliedDate,
                                    status: HomeServiceStatus.approved,
                                  );
                                });
                              },
                              onReject: () {
                                // TODO: connect reject API
                                setState(() {
                                  final i = _allProviders.indexWhere(
                                    (p) => p.id == provider.id,
                                  );
                                  _allProviders[i] = HomeServiceManagementModel(
                                    id: provider.id,
                                    name: provider.name,
                                    role: provider.role,
                                    rating: provider.rating,
                                    visitsCount: provider.visitsCount,
                                    location: provider.location,
                                    licenseNumber: provider.licenseNumber,
                                    appliedDate: provider.appliedDate,
                                    status: HomeServiceStatus.rejected,
                                  );
                                });
                              },
                            );
                          },
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color:
                isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:
                isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
