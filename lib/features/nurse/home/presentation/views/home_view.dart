import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/function/navigation.dart';
import '../../data/models/nurse_request_model.dart';
import 'widgets/request_card_widget.dart';

class NurseHomeView extends StatefulWidget {
  const NurseHomeView({super.key});

  @override
  State<NurseHomeView> createState() => _NurseHomeViewState();
}

class _NurseHomeViewState extends State<NurseHomeView> {
  // TODO: replace with real API data
  final List<NurseRequestModel> _requests = [
    NurseRequestModel(
      id: '1',
      patientName: 'Ahmed Al-Mansouri',
      serviceType: 'Nursing Care',
      location: 'Al Barsha, Dubai',
      distanceKm: 2.3,
      date: 'Today',
      time: '2:00 PM',
      durationHours: 4,
      price: 320,
      isUrgent: true,
    ),
    NurseRequestModel(
      id: '2',
      patientName: 'Fatima Hassan',
      serviceType: 'Physiotherapy',
      location: 'Jumeirah, Dubai',
      distanceKm: 5.1,
      date: 'Today',
      time: '4:00 PM',
      durationHours: 2,
      price: 180,
      isUrgent: false,
    ),
  ];

  void _onAccept(NurseRequestModel request) {
    // TODO: connect accept API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request from ${request.patientName} accepted!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onReject(NurseRequestModel request) {
    // TODO: connect reject API
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Reject Request'),
            content: Text(
              'Are you sure you want to reject ${request.patientName}\'s request?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(
                    () => _requests.removeWhere((r) => r.id == request.id),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Reject',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: GoogleFonts.archivo(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fatima Hassan', // TODO: replace with real name
                        style: GoogleFonts.archivo(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: ()async{
                       await AppPrefs.clearToken();
                  CustomReplacementNavigation(context, '/login');
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Section Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Service Requests',
                    style: GoogleFonts.archivo(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  Text(
                    '${_requests.length} available near you',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Requests List ──
            Expanded(
              child:
                  _requests.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 56,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No requests available',
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _requests.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final request = _requests[index];
                          return RequestCardWidget(
                            request: request,
                            onAccept: () => _onAccept(request),
                            onReject: () => _onReject(request),
                            onViewDetails: () {
                              // TODO: navigate to request details
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
