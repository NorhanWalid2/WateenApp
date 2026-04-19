import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/dashboard_model.dart';
import 'widgets/stats_card_widget.dart';
import 'widgets/pending_approval_card_widget.dart';
import 'widgets/recent_activity_item_widget.dart';
import 'widgets/quick_action_button_widget.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  // TODO: replace with real API data
  static final DashboardStatsModel _stats = DashboardStatsModel(
    totalPatients: 1248,
    activeDoctors: 86,
    homeServices: 145,
    appointmentsToday: 42,
    patientsChange: 12,
    doctorsChange: 8,
    homeServicesChange: 15,
    appointmentsChange: -3,
  );

  static final List<PendingApprovalModel> _pendingApprovals = [
    PendingApprovalModel(
      id: '1',
      name: 'Dr. Sarah Ahmed',
      role: 'Doctor',
      specialty: 'Cardiologist',
      timeAgo: '2 hours ago',
    ),
    PendingApprovalModel(
      id: '2',
      name: 'Fatima Hassan',
      role: 'Home Service',
      specialty: 'Nurse',
      timeAgo: '5 hours ago',
    ),
    PendingApprovalModel(
      id: '3',
      name: 'Dr. Mohammed Ali',
      role: 'Doctor',
      specialty: 'Pediatrician',
      timeAgo: '1 day ago',
    ),
  ];

  static final List<RecentActivityModel> _activities = [
    RecentActivityModel(
      title: 'Doctor Approved',
      subtitle: 'Dr. Ahmed Khan',
      timeAgo: '10 minutes ago',
      type: ActivityType.approved,
    ),
    RecentActivityModel(
      title: 'New Patient Registration',
      subtitle: 'Ali Hassan',
      timeAgo: '25 minutes ago',
      type: ActivityType.registered,
    ),
    RecentActivityModel(
      title: 'Home Service Completed',
      subtitle: 'Nurse Sarah',
      timeAgo: '1 hour ago',
      type: ActivityType.completed,
    ),
    RecentActivityModel(
      title: 'Doctor Rejected',
      subtitle: 'Dr. John Doe',
      timeAgo: '2 hours ago',
      type: ActivityType.rejected,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Wateen Logo
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

                  // Hamburger menu
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
                      'Dashboard',
                      style: GoogleFonts.archivo(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome to Wateen Healthcare Admin Portal',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Stats Cards ──
                    StatsCardWidget(
                      icon: Icons.people_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      iconBgColor: const Color(0xFFEFF6FF),
                      label: 'Total Patients',
                      value: _stats.totalPatients.toString(),
                      changePercent: _stats.patientsChange,
                    ),
                    const SizedBox(height: 12),
                    StatsCardWidget(
                      icon: Icons.medical_services_rounded,
                      iconColor: const Color(0xFF16A34A),
                      iconBgColor: const Color(0xFFECFDF5),
                      label: 'Active Doctors',
                      value: _stats.activeDoctors.toString(),
                      changePercent: _stats.doctorsChange,
                    ),
                    const SizedBox(height: 12),
                    StatsCardWidget(
                      icon: Icons.home_rounded,
                      iconColor: const Color(0xFF7C3AED),
                      iconBgColor: const Color(0xFFF5F3FF),
                      label: 'Home Services',
                      value: _stats.homeServices.toString(),
                      changePercent: _stats.homeServicesChange,
                    ),
                    const SizedBox(height: 12),
                    StatsCardWidget(
                      icon: Icons.calendar_today_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      iconBgColor: const Color(0xFFFFFBEB),
                      label: 'Appointments Today',
                      value: _stats.appointmentsToday.toString(),
                      changePercent: _stats.appointmentsChange,
                    ),

                    const SizedBox(height: 24),

                    // ── Pending Approvals ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pending Approvals',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inverseSurface,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_pendingApprovals.length} Pending',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Approval cards
                          ..._pendingApprovals.map(
                            (approval) => PendingApprovalCardWidget(
                              approval: approval,
                              onApprove: () {
                                // TODO: connect approve API
                              },
                              onReject: () {
                                // TODO: connect reject API
                              },
                            ),
                          ),

                          const SizedBox(height: 8),

                          // View all
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: navigate to doctors management
                              },
                              child: Text(
                                'View All Pending',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Recent Activities ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Activities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inverseSurface,
                                ),
                              ),
                              Icon(
                                Icons.access_time_rounded,
                                size: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Activity items
                          ..._activities.map(
                            (activity) =>
                                RecentActivityItemWidget(activity: activity),
                          ),

                          const SizedBox(height: 4),

                          // View all
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: navigate to activities
                              },
                              child: Text(
                                'View All Activities',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Quick Actions ──
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    QuickActionButtonWidget(
                      icon: Icons.medical_services_rounded,
                      title: 'Review Doctor Applications',
                      subtitle: '8 pending',
                      onTap: () {
                        // TODO: navigate to doctors management
                      },
                    ),
                    const SizedBox(height: 10),
                    QuickActionButtonWidget(
                      icon: Icons.home_rounded,
                      title: 'Review Home Service',
                      subtitle: '4 pending',
                      onTap: () {
                        // TODO: navigate to home service management
                      },
                    ),
                    const SizedBox(height: 10),
                    QuickActionButtonWidget(
                      icon: Icons.people_rounded,
                      title: 'Manage Patients',
                      onTap: () {
                        // TODO: navigate to patients management
                      },
                    ),

                    const SizedBox(height: 20),
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
