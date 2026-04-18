import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/health/data/models/vital_type_model.dart';
import 'package:wateen_app/features/patient/health/data/models/vital_entry_model.dart';
import 'package:wateen_app/features/patient/health/presentation/cubit/health_cubit.dart';
import 'package:wateen_app/features/patient/health/presentation/cubit/health_state.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/abnormal_alert_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/vital_card_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/recent_entry_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/manual_entry_sheet.dart';
import 'package:wateen_app/core/function/toast_message.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HealthCubit()..fetchVitals(),
      child: const HealthViewBody(),
    );
  }
}

class HealthViewBody extends StatefulWidget {
  const HealthViewBody({super.key});

  @override
  State<HealthViewBody> createState() => HealthViewBodyState();
}

class RecentEntryItem {
  final VitalEntryModel entry;
  final String label;
  final Color color;
  final IconData icon;

  RecentEntryItem({
    required this.entry,
    required this.label,
    required this.color,
    required this.icon,
  });
}

class HealthViewBodyState extends State<HealthViewBody> {
  final List<RecentEntryItem> recentEntries = [];

  List<VitalTypeModel> buildVitals(AppLocalizations l10n, HealthState state) {
    final sys = state.systolic ?? 0;
    final dia = state.diastolic ?? 0;
    final hr = state.heartRate ?? 0;
    final sug = state.sugar ?? 0;

    return [
      VitalTypeModel(
        type: VitalType.bloodPressure,
        label: l10n.bloodPressure,
        unit: 'mmHg',
        icon: Icons.favorite_rounded,
        color: const Color(0xFFE53935),
        currentValue: sys > 0 ? '${sys.toInt()}/${dia.toInt()}' : '—',
        min: 60,
        max: 180,
      ),
      VitalTypeModel(
        type: VitalType.bloodSugar,
        label: l10n.bloodSugar,
        unit: 'mg/dL',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF1E88E5),
        currentValue: sug > 0 ? '${sug.toInt()}' : '—',
        min: 70,
        max: 200,
      ),
      VitalTypeModel(
        type: VitalType.heartRate,
        label: l10n.heartRate,
        unit: 'bpm',
        icon: Icons.monitor_heart_rounded,
        color: const Color(0xFF43A047),
        currentValue: hr > 0 ? '${hr.toInt()}' : '—',
        min: 40,
        max: 180,
      ),
    ];
  }

  List<Map<String, dynamic>> buildInsights(HealthState state) {
    if (!state.hasData) return [];

    final sys = state.systolic ?? 0;
    final dia = state.diastolic ?? 0;
    final hr = state.heartRate ?? 0;
    final sug = state.sugar ?? 0;
    final insights = <Map<String, dynamic>>[];

    if (sys > 0) {
      if (sys > 140 || dia > 90) {
        insights.add({
          'text':
              'Blood pressure is HIGH (${sys.toInt()}/${dia.toInt()} mmHg). Consider consulting your doctor.',
          'color': const Color(0xFFE53935),
          'icon': Icons.warning_amber_rounded,
        });
      } else if (sys < 90 || dia < 60) {
        insights.add({
          'text':
              'Blood pressure is LOW (${sys.toInt()}/${dia.toInt()} mmHg). Stay hydrated.',
          'color': const Color(0xFFE53935),
          'icon': Icons.warning_amber_rounded,
        });
      } else {
        insights.add({
          'text':
              'Blood pressure is normal (${sys.toInt()}/${dia.toInt()} mmHg). Keep it up!',
          'color': const Color(0xFF43A047),
          'icon': Icons.check_circle_outline_rounded,
        });
      }
    }
    if (sug > 0) {
      if (sug > 140) {
        insights.add({
          'text':
              'Blood sugar is HIGH (${sug.toInt()} mg/dL). Avoid sugary foods.',
          'color': const Color(0xFFE53935),
          'icon': Icons.warning_amber_rounded,
        });
      } else if (sug < 70) {
        insights.add({
          'text': 'Blood sugar is LOW (${sug.toInt()} mg/dL). Eat something.',
          'color': const Color(0xFFE53935),
          'icon': Icons.warning_amber_rounded,
        });
      } else {
        insights.add({
          'text': 'Blood sugar is normal (${sug.toInt()} mg/dL).',
          'color': const Color(0xFF43A047),
          'icon': Icons.check_circle_outline_rounded,
        });
      }
    }
    if (hr > 0) {
      if (hr > 100) {
        insights.add({
          'text': 'Heart rate is HIGH (${hr.toInt()} bpm). Try to relax.',
          'color': const Color(0xFFE53935),
          'icon': Icons.warning_amber_rounded,
        });
      } else if (hr < 60) {
        insights.add({
          'text': 'Heart rate is LOW (${hr.toInt()} bpm).',
          'color': const Color(0xFFE8A838),
          'icon': Icons.info_outline_rounded,
        });
      } else {
        insights.add({
          'text': 'Heart rate is good (${hr.toInt()} bpm).',
          'color': const Color(0xFF43A047),
          'icon': Icons.check_circle_outline_rounded,
        });
      }
    }
    if (insights.isEmpty) {
      insights.add({
        'text': 'Add your vitals to get personalized health insights.',
        'color': const Color(0xFF1E88E5),
        'icon': Icons.lightbulb_outline_rounded,
      });
    }
    return insights;
  }

  void openManualEntry(BuildContext context, List<VitalTypeModel> vitals) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => BlocProvider.value(
            value: context.read<HealthCubit>(),
            child: ManualEntrySheet(
              vitals: vitals,
              onSubmit: (type, value, secondValue, notes) {
                final cubit = context.read<HealthCubit>();
                final s = cubit.state;

                double systolic = s.systolic ?? 0;
                double diastolic = s.diastolic ?? 0;
                double heartRate = s.heartRate ?? 0;
                double sugar = s.sugar ?? 0;

                switch (type) {
                  case VitalType.bloodPressure:
                    systolic = value;
                    diastolic = secondValue ?? diastolic;
                    break;
                  case VitalType.bloodSugar:
                    sugar = value;
                    break;
                  case VitalType.heartRate:
                    heartRate = value;
                    break;
                  case VitalType.oxygen:
                    break;
                }

                cubit.updateVitals(
                  systolic: systolic,
                  diastolic: diastolic,
                  heartRate: heartRate,
                  sugar: sugar,
                );

                final vital = vitals.firstWhere((v) => v.type == type);
                setState(() {
                  recentEntries.insert(
                    0,
                    RecentEntryItem(
                      entry: VitalEntryModel(
                        value: value,
                        secondValue: secondValue,
                        time: DateTime.now(),
                        unit: vital.unit,
                      ),
                      label: vital.label,
                      color: vital.color,
                      icon: vital.icon,
                    ),
                  );
                });
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<HealthCubit, HealthState>(
      listener: (context, state) {
        if (state is HealthUpdateSuccess) {
          showToastMessage(context, 'Vitals updated!', ToastType.success);
        } else if (state is HealthError) {
          showToastMessage(context, state.message, ToastType.error);
        }
      },
      builder: (context, state) {
        final vitals = buildVitals(l10n, state);
        final insights = buildInsights(state);

        return SafeArea(
          child: Scaffold(
            body:
                state is HealthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Header ────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.healthTracking,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () =>
                                        context
                                            .read<HealthCubit>()
                                            .fetchVitals(),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Vital Cards ───────────────────────────
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.6,
                            children:
                                vitals
                                    .map((v) => VitalCardWidget(vital: v))
                                    .toList(),
                          ),
                          const SizedBox(height: 20),

                          // ── Health Insights ───────────────────────
                          Text(
                            l10n.healthInsights,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children:
                                  insights.map((insight) {
                                    final color = insight['color'] as Color;
                                    final icon = insight['icon'] as IconData;
                                    final text = insight['text'] as String;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(icon, size: 16, color: color),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              text,
                                              style: textTheme.bodySmall
                                                  ?.copyWith(height: 1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Add Manual Entry ──────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => openManualEntry(context, vitals),
                              icon: Icon(
                                Icons.add_rounded,
                                color: colorScheme.secondary,
                              ),
                              label: Text(
                                l10n.addManualEntry,
                                style: TextStyle(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: colorScheme.secondary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }
}
