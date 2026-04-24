import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
 import 'package:wateen_app/features/patient/appointments/presentation/cubit/nurse_request_cubit.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/nurse_request_state.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/nurse_request_card_widget.dart';

class NurseRequestsView extends StatefulWidget {
  const NurseRequestsView({super.key});

  @override
  State<NurseRequestsView> createState() => NurseRequestsViewState();
}

class NurseRequestsViewState extends State<NurseRequestsView>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => false; // ← always re-fetch when tab opens

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => NurseRequestsCubit()..fetchRequests(),
      child: const NurseRequestsBody(),
    );
  }
}

class NurseRequestsBody extends StatelessWidget {
  const NurseRequestsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<NurseRequestsCubit, NurseRequestsState>(
      builder: (context, state) {
        if (state is NurseRequestsLoading) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const ShimmerListItemWidget(),
          );
        }

        if (state is NurseRequestsError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(state.message,
                    style:
                        TextStyle(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () =>
                      context.read<NurseRequestsCubit>().fetchRequests(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                      foregroundColor: colorScheme.secondary),
                ),
              ],
            ),
          );
        }

        if (state is NurseRequestsLoaded && state.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.medical_services_outlined,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(
                  'No nurse requests yet',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        if (state is NurseRequestsLoaded) {
          return RefreshIndicator(
            color: colorScheme.secondary,
            onRefresh: () =>
                context.read<NurseRequestsCubit>().fetchRequests(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  NurseRequestCardWidget(request: state.requests[i]),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}