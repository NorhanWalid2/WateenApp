import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/nurse/home/data/models/nurse_request_model.dart';
import 'package:wateen_app/features/nurse/home/presentation/cubit/nurse_home_cubit.dart';
import 'package:wateen_app/features/nurse/home/presentation/cubit/nurse_home_state.dart';

class NurseHomeView extends StatelessWidget {
  const NurseHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NurseHomeCubit()..fetchRequests(),
      child: const NurseHomeBody(),
    );
  }
}

class NurseHomeBody extends StatelessWidget {
  const NurseHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<NurseHomeCubit, NurseHomeState>(
      listener: (context, state) {
        if (state is NurseHomeActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
        } else if (state is NurseHomeActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final requests =
            state is NurseHomeLoaded
                ? state.requests
                : <NurseHomeRequestModel>[];
        final isLoading = state is NurseHomeLoading;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
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
                          'Nurse', // TODO: replace with real name from profile
                          style: GoogleFonts.archivo(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        await AppPrefs.clearToken();
                        CustomReplacementNavigation(context, '/login');
                      },
                      // () =>
                      //     context.read<NurseHomeCubit>().fetchRequests(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Section Header ────────────────────────────────────
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
                        color: colorScheme.inverseSurface,
                      ),
                    ),
                    if (!isLoading)
                      Text(
                        '${requests.length} available',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Requests List ─────────────────────────────────────
              Expanded(
                child:
                    isLoading
                        ? ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: 3,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, __) => const ShimmerListItemWidget(),
                        )
                        : state is NurseHomeError
                        ? Center(
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
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: () async {
                                  await AppPrefs.clearToken();
                                  CustomReplacementNavigation(
                                    context,
                                    '/login',
                                  );
                                },
                                // () =>
                                //     context
                                //         .read<NurseHomeCubit>()
                                //         .fetchRequests(),
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Retry'),
                                style: TextButton.styleFrom(
                                  foregroundColor: colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        )
                        : requests.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_rounded,
                                size: 56,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No requests available',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: requests.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return NurseRequestCardWidget(request: request);
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NurseRequestCardWidget extends StatelessWidget {
  final NurseHomeRequestModel request;

  const NurseRequestCardWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<NurseHomeCubit, NurseHomeState>(
      builder: (context, state) {
        final isActing =
            state is NurseHomeActionLoading && state.requestId == request.id;

        return Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.patientName ?? 'Patient',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          request.serviceDescription,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: colorScheme.outline.withOpacity(0.2)),
              const SizedBox(height: 12),

              // ── Details ──────────────────────────────────────
              NurseRequestDetailRowWidget(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: request.address,
              ),
              const SizedBox(height: 6),
              NurseRequestDetailRowWidget(
                icon: Icons.access_time_rounded,
                label: 'Time',
                value: request.formattedTime,
              ),

              const SizedBox(height: 16),

              // ── Actions ──────────────────────────────────────
              if (request.status == 0) ...[
                const SizedBox(height: 16),
                isActing
                    ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.secondary,
                        strokeWidth: 2,
                      ),
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showRejectDialog(context),
                            icon: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: colorScheme.error,
                            ),
                            label: Text(
                              'Reject',
                              style: TextStyle(color: colorScheme.error),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                () =>
                                    context.read<NurseHomeCubit>().updateStatus(
                                      requestId: request.id,
                                      accept: true,
                                    ),
                            icon: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Accept',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
              ] else ...[
                // ── Show completion message when actioned ─────────
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        request.status == 1
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.status == 1
                        ? '✓ You accepted this request'
                        : '✗ You rejected this request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          request.status == 1
                              ? const Color(0xFF16A34A)
                              : colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ── Status badge ─────────────────────────────────────
  Widget _buildStatusBadge() {
    switch (request.status) {
      case 1:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.3)),
          ),
          child: const Text(
            'Approved',
            style: TextStyle(
              color: Color(0xFF16A34A),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 2:
        return Builder(
          builder:
              (context) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Rejected',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        );
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: const Text(
            'Pending',
            style: TextStyle(
              color: Color(0xFFF59E0B),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }

  void _showRejectDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Reject Request'),
            content: Text(
              'Reject ${request.patientName ?? "this"} request for "${request.serviceDescription}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<NurseHomeCubit>().updateStatus(
                    requestId: request.id,
                    accept: false,
                  );
                },
                child: Text(
                  'Reject',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }
}

class NurseRequestDetailRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const NurseRequestDetailRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.inverseSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
