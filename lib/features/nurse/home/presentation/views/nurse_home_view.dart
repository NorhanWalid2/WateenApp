import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/nurse/home/data/models/nurse_request_model.dart';
import 'package:wateen_app/features/nurse/home/presentation/cubit/nurse_home_cubit.dart';
import 'package:wateen_app/features/nurse/home/presentation/cubit/nurse_home_state.dart';
import 'package:wateen_app/features/nurse/layout/widgets/nurse_top_bar_widget.dart';

class NurseHomeView extends StatelessWidget {
  final VoidCallback onMenuTap;

  const NurseHomeView({
    super.key,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NurseHomeCubit()..fetchRequests(),
      child: NurseHomeBody(onMenuTap: onMenuTap),
    );
  }
}

class NurseHomeBody extends StatelessWidget {
  final VoidCallback onMenuTap;

  const NurseHomeBody({
    super.key,
    required this.onMenuTap,
  });

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
        final requests = state is NurseHomeLoaded
            ? state.requests
            : <NurseHomeRequestModel>[];

        final isLoading = state is NurseHomeLoading;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NurseTopBarWidget(onMenuTap: onMenuTap),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Requests',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        isLoading ? 'Loading...' : '${requests.length} available',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 20),
            
                        // ── List ────────────────────────────────────
                        if (isLoading)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, __) =>
                                const ShimmerListItemWidget(),
                          )
                        else if (state is NurseHomeError)
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.wifi_off_rounded,
                                      size: 48,
                                      color: colorScheme.onSurfaceVariant),
                                  const SizedBox(height: 12),
                                  Text(state.message,
                                      style: TextStyle(
                                          color:
                                              colorScheme.onSurfaceVariant)),
                                  const SizedBox(height: 16),
                                  TextButton.icon(
                                    onPressed: () => context
                                        .read<NurseHomeCubit>()
                                        .fetchRequests(),
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: const Text('Retry'),
                                    style: TextButton.styleFrom(
                                        foregroundColor:
                                            colorScheme.secondary),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (requests.isEmpty)
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Icon(Icons.inbox_rounded,
                                      size: 56,
                                      color: colorScheme.onSurfaceVariant),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No requests available',
                                    style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: requests.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) =>
                                NurseRequestCardWidget(request: requests[i]),
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
}

// ── Card Widget ───────────────────────────────────────────────────────────────
class NurseRequestCardWidget extends StatelessWidget {
  final NurseHomeRequestModel request;

  const NurseRequestCardWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<NurseHomeCubit, NurseHomeState>(
      builder: (context, state) {
        final isActing = state is NurseHomeActionLoading &&
            state.requestId == request.id;

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
                    child: Icon(Icons.person_rounded,
                        color: colorScheme.secondary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.patientName ?? 'Patient',
                          style: textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          request.serviceDescription,
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(colorScheme),
                ],
              ),

              const SizedBox(height: 12),
              Divider(
                  height: 1, color: colorScheme.outline.withOpacity(0.2)),
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

              // ── Actions ──────────────────────────────────────
              if (request.status == 0) ...[
                const SizedBox(height: 16),
                isActing
                    ? Center(
                        child: CircularProgressIndicator(
                            color: colorScheme.secondary, strokeWidth: 2))
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showRejectDialog(context),
                              icon: Icon(Icons.close_rounded,
                                  size: 16, color: colorScheme.error),
                              label: Text('Reject',
                                  style:
                                      TextStyle(color: colorScheme.error)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colorScheme.error),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => context
                                  .read<NurseHomeCubit>()
                                  .updateStatus(
                                      requestId: request.id, accept: true),
                              icon: const Icon(Icons.check_rounded,
                                  size: 16, color: Colors.white),
                              label: const Text('Accept',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
              ] else if (request.status == 1) ...[
                const SizedBox(height: 16),
                isActing
                    ? Center(
                        child: CircularProgressIndicator(
                            color: colorScheme.secondary, strokeWidth: 2))
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showCompleteDialog(context),
                          icon: const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: Colors.white),
                          label: const Text('Mark Visit Complete',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
              ] else ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: request.status == 2
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.status == 2
                        ? '✓ Visit completed'
                        : '✗ Request rejected',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: request.status == 2
                          ? const Color(0xFF3B82F6)
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

  Widget _buildStatusBadge(ColorScheme colorScheme) {
    final label = request.statusLabel;
    final color = request.statusColor(colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(request.statusIcon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Request'),
        content: Text(
            'Reject ${request.patientName ?? "this"} request for "${request.serviceDescription}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NurseHomeCubit>().updateStatus(
                  requestId: request.id, accept: false);
            },
            child:
                Text('Reject', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Complete Visit'),
        content: Text(
            'Mark visit for ${request.patientName ?? "this patient"} as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<NurseHomeCubit>()
                  .completeRequest(requestId: request.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Complete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────────────────
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
        Text('$label: ',
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
                color: colorScheme.inverseSurface,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}