import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/widgets/shimmer%20card%20skeletons.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/appointment_state.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/nurse_requests_view.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/appointment_card_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/cancel_appointment_dialog.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => AppointmentsViewState();
}

class AppointmentsViewState extends State<AppointmentsView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 2 && !tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => AppointmentCubit()..fetchAppointments(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(l10n.appointments, style: textTheme.headlineMedium),
              ),
              const SizedBox(height: 12),

              TabBar(
                controller: tabController,
                labelColor: colorScheme.secondary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.secondary,
                indicatorWeight: 2,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: l10n.upcoming),
                  Tab(text: l10n.past),
                  const Tab(text: 'Nurse Requests'),
                ],
              ),

              Expanded(
                child: BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    // ── Loading ──
                    if (state is AppointmentLoading) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, __) => const ShimmerListItemWidget(),
                      );
                    }

                    // ── Error ──
                    if (state is AppointmentError) {
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
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed:
                                  () =>
                                      context
                                          .read<AppointmentCubit>()
                                          .fetchAppointments(),
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

                    // ── Loaded ──
                    final upcoming =
                        state is AppointmentLoaded ? state.upcoming : [];
                    final past = state is AppointmentLoaded ? state.past : [];

                    return TabBarView(
                      controller: tabController,
                      children: [
                        // ── Upcoming Tab ──
                        upcoming.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 48,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No upcoming appointments',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : RefreshIndicator(
                              color: colorScheme.secondary,
                              onRefresh:
                                  () =>
                                      context
                                          .read<AppointmentCubit>()
                                          .fetchAppointments(),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                itemCount: upcoming.length,
                                itemBuilder:
                                    (ctx, i) => AppointmentCardWidget(
                                      appointment: upcoming[i],
                                      onTap:
                                          () => CustomNavigation(
                                            context,
                                            '/appointmentsDetails',
                                          ),
                                      onAction: () {},
                                      onReschedule:
                                          () => CustomNavigation(
                                            context,
                                            '/rescheduleAppointments',
                                          ),
                                      onCancel:
                                          () => showDialog(
                                            context: context,
                                            builder:
                                                (_) => CancelAppointmentDialog(
                                                  onConfirm:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  onGoBack:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                ),
                                          ),
                                    ),
                              ),
                            ),

                        // ── Past Tab ──
                        past.isEmpty
                            ? Center(
                              child: Text(
                                l10n.noPastAppointments,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                            : RefreshIndicator(
                              color: colorScheme.secondary,
                              onRefresh:
                                  () =>
                                      context
                                          .read<AppointmentCubit>()
                                          .fetchAppointments(),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                itemCount: past.length,
                                itemBuilder:
                                    (ctx, i) => AppointmentCardWidget(
                                      appointment: past[i],
                                      onTap:
                                          () => CustomNavigation(
                                            context,
                                            '/appointmentsDetails',
                                          ),
                                      onAction: () {},
                                      onReschedule:
                                          () => CustomNavigation(
                                            context,
                                            '/rescheduleAppointments',
                                          ),
                                      onCancel:
                                          () => showDialog(
                                            context: context,
                                            builder:
                                                (_) => CancelAppointmentDialog(
                                                  onConfirm:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  onGoBack:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                ),
                                          ),
                                    ),
                              ),
                            ),

                        // ── Nurse Requests Tab ──
                        const NurseRequestsView(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
