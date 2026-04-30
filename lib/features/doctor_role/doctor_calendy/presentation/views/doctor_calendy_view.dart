import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wateen_app/features/doctor_role/doctor_calendy/presentation/cubit/doctor_calendy_cubit.dart';
import 'package:wateen_app/features/doctor_role/doctor_calendy/presentation/cubit/doctor_calendy_state.dart';
 

class DoctorCalendlyView extends StatelessWidget {
  const DoctorCalendlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorCalendlyCubit()..fetchCalendlyData(),
      child: const _DoctorCalendlyBody(),
    );
  }
}

class _DoctorCalendlyBody extends StatelessWidget {
  const _DoctorCalendlyBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: BlocConsumer<DoctorCalendlyCubit, DoctorCalendlyState>(
          listener: (context, state) async {
            if (state is DoctorCalendlyConnected && state.connectUrl.isNotEmpty) {
              bool launched = false;
              final uri = Uri.parse(state.connectUrl);

              // On Android: use android_intent_plus which bypasses MIUI restrictions
              if (Platform.isAndroid) {
                try {
                  final intent = AndroidIntent(
                    action: 'action_view',
                    data: state.connectUrl,
                    flags: [
                      // FLAG_ACTIVITY_NEW_TASK — required when starting from non-activity context
                      0x10000000,
                    ],
                  );
                  await intent.launch();
                  launched = true;
                } catch (_) {}
              }

              // iOS or Android fallback — use url_launcher
              if (!launched) {
                for (final mode in [
                  LaunchMode.externalApplication,
                  LaunchMode.inAppBrowserView,
                  LaunchMode.platformDefault,
                ]) {
                  if (launched) break;
                  try { launched = await launchUrl(uri, mode: mode); } catch (_) {}
                }
              }

              // Last resort — show copyable dialog
              if (!launched && context.mounted) {
                _showCalendlyUrlDialog(context, state.connectUrl, colorScheme);
                return;
              }

              // After returning from browser, refresh data
              if (context.mounted) {
                context.read<DoctorCalendlyCubit>().fetchCalendlyData();
              }
            }
            if (state is DoctorCalendlyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage Availability',
                            style: GoogleFonts.archivo(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Powered by Calendly',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Body ─────────────────────────────────────────────────
                Expanded(
                  child: switch (state) {
                    DoctorCalendlyLoading() ||
                    DoctorCalendlyConnecting() =>
                      const Center(child: CircularProgressIndicator()),

                    DoctorCalendlyError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<DoctorCalendlyCubit>()
                            .fetchCalendlyData(),
                      ),

                    DoctorCalendlyLoaded(
                      :final isCalendlyLinked,
                      :final eventTypes,
                      :final slots,
                    ) =>
                      isCalendlyLinked
                          ? _LinkedView(
                              eventTypes: eventTypes,
                              slots: slots,
                            )
                          : _NotLinkedView(
                              onConnect: () => context
                                  .read<DoctorCalendlyCubit>()
                                  .connectCalendly(),
                              onRefresh: () => context
                                  .read<DoctorCalendlyCubit>()
                                  .fetchCalendlyData(),
                            ),

                    _ => const SizedBox.shrink(),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Fallback dialog for devices that block browser launch (e.g. MIUI) ────────
void _showCalendlyUrlDialog(
    BuildContext context, String url, ColorScheme colorScheme) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Open in Browser'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your device prevented automatic browser launch. Copy the link below and open it in your browser to connect Calendly:',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(
              url,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: url));
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Link copied! Open your browser and paste it.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.white),
          label: const Text('Copy Link',
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            elevation: 0,
          ),
        ),
      ],
    ),
  );
}


// ── NOT LINKED — show connect prompt ─────────────────────────────────────────

class _NotLinkedView extends StatelessWidget {
  final VoidCallback onConnect;
  final VoidCallback onRefresh;

  const _NotLinkedView({required this.onConnect, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Calendly logo placeholder
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF006BFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 50,
              color: Color(0xFF006BFF),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Connect Your Calendly',
            style: GoogleFonts.archivo(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colorScheme.inverseSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            'Link your Calendly account so patients can book appointments directly into your available time slots.',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // ── Benefits ──
          _BenefitRow(
            icon: Icons.access_time_rounded,
            text: 'Set your available hours once',
          ),
          const SizedBox(height: 12),
          _BenefitRow(
            icon: Icons.people_outline_rounded,
            text: 'Patients book directly into your calendar',
          ),
          const SizedBox(height: 12),
          _BenefitRow(
            icon: Icons.notifications_outlined,
            text: 'Automatic reminders for both parties',
          ),
          const SizedBox(height: 12),
          _BenefitRow(
            icon: Icons.sync_rounded,
            text: 'Syncs with your existing appointments',
          ),

          const SizedBox(height: 40),

          // ── Connect Button ──
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.link_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Connect Calendly Account',
                    style: GoogleFonts.archivo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'You\'ll be redirected to Calendly to authorize access.',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.outlineVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // ── Already completed OAuth? Tap to verify ──
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: Icon(
              Icons.check_circle_outline_rounded,
              size: 18,
              color: colorScheme.secondary,
            ),
            label: Text(
              "I've connected — verify my account",
              style: TextStyle(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              side: BorderSide(color: colorScheme.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── LINKED — show event types + slots ────────────────────────────────────────

class _LinkedView extends StatelessWidget {
  final List<CalendlyEventTypeModel> eventTypes;
  final List<CalendlySlotModel> slots;

  const _LinkedView({required this.eventTypes, required this.slots});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Group slots by date
    final Map<String, List<CalendlySlotModel>> slotsByDate = {};
    for (final slot in slots) {
      slotsByDate.putIfAbsent(slot.date, () => []).add(slot);
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<DoctorCalendlyCubit>().fetchCalendlyData(),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Connected badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Calendly is connected',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Event Types ──────────────────────────────────────────────
          Text(
            'Your Event Types',
            style: GoogleFonts.archivo(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colorScheme.inverseSurface,
            ),
          ),
          const SizedBox(height: 12),

          if (eventTypes.isEmpty)
            _EmptyCard(
              message: 'No event types found.\nCreate them in your Calendly dashboard.',
            )
          else
            ...eventTypes.map((et) => _EventTypeCard(eventType: et)),

          const SizedBox(height: 28),

          // ── Upcoming Slots ───────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Slots',
                style: GoogleFonts.archivo(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.inverseSurface,
                ),
              ),
              Text(
                '${slots.length} total',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.outlineVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (slots.isEmpty)
            _EmptyCard(
              message: 'No upcoming slots.\nUpdate your availability in Calendly.',
            )
          else
            ...slotsByDate.entries.map(
              (entry) => _SlotDaySection(
                date: entry.key,
                slots: entry.value,
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _EventTypeCard extends StatelessWidget {
  final CalendlyEventTypeModel eventType;

  const _EventTypeCard({required this.eventType});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color dotColor;
    try {
      final hex = eventType.color.replaceAll('#', '');
      dotColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      dotColor = colorScheme.secondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventType.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${eventType.durationMinutes} minutes',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: eventType.active
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              eventType.active ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: eventType.active ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotDaySection extends StatelessWidget {
  final String date;
  final List<CalendlySlotModel> slots;

  const _SlotDaySection({required this.date, required this.slots});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.outlineVariant,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots
              .map((slot) => _SlotChip(displayTime: slot.displayTime))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  final String displayTime;

  const _SlotChip({required this.displayTime});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.secondary.withOpacity(0.3),
        ),
      ),
      child: Text(
        displayTime,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.secondary,
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF006BFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF006BFF)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.inverseSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.outlineVariant,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text('Retry',
                  style: TextStyle(color: colorScheme.secondary)),
            ),
          ],
        ),
      ),
    );
  }
}