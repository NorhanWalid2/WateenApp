import 'package:flutter/material.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/health/data/models/vital_type_model.dart';
import 'package:wateen_app/features/patient/health/data/models/vital_entry_model.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/abnormal_alert_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/vital_card_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/recent_entry_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/bp_trend_chart_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/health_insights_widget.dart';
import 'package:wateen_app/features/patient/health/presentation/views/widgets/manual_entry_sheet.dart';

class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  State<HealthView> createState() => HealthViewState();
}

class HealthViewState extends State<HealthView> {
  final List<VitalEntryModel> recentEntries = [
    VitalEntryModel(
      value: 120,
      secondValue: 80,
      time: DateTime.now().subtract(const Duration(hours: 2)),
      unit: 'mmHg',
    ),
    VitalEntryModel(
      value: 110,
      time: DateTime.now().subtract(const Duration(hours: 5)),
      unit: 'mg/dL',
    ),
    VitalEntryModel(
      value: 72,
      time: DateTime.now().subtract(const Duration(hours: 8)),
      unit: 'bpm',
    ),
  ];

  // ✅ method بتاخد l10n بدل const list
  List<VitalTypeModel> buildVitals(AppLocalizations l10n) => [
    VitalTypeModel(
      type: VitalType.bloodPressure,
      label: l10n.bloodPressure,
      unit: 'mmHg',
      icon: Icons.favorite_rounded,
      color: const Color(0xFFE53935),
      currentValue: '120/80',
      min: 60,
      max: 180,
    ),
    VitalTypeModel(
      type: VitalType.bloodSugar,
      label: l10n.bloodSugar,
      unit: 'mg/dL',
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF1E88E5),
      currentValue: '110',
      min: 70,
      max: 200,
    ),
    VitalTypeModel(
      type: VitalType.heartRate,
      label: l10n.heartRate,
      unit: 'bpm',
      icon: Icons.monitor_heart_rounded,
      color: const Color(0xFF43A047),
      currentValue: '72',
      min: 40,
      max: 180,
    ),
    VitalTypeModel(
      type: VitalType.oxygen,
      label: l10n.oxygen,
      unit: '%',
      icon: Icons.air_rounded,
      color: const Color(0xFF8E24AA),
      currentValue: '98',
      min: 80,
      max: 100,
    ),
  ];

  void openManualEntry() {
    final l10n = AppLocalizations.of(context)!;
    final vitals = buildVitals(l10n);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ManualEntrySheet(
            vitals: vitals,
            onSubmit: (type, value, secondValue, notes) {
              setState(() {
                recentEntries.insert(
                  0,
                  VitalEntryModel(
                    value: value,
                    secondValue: secondValue,
                    time: DateTime.now(),
                    unit: vitals.firstWhere((v) => v.type == type).unit,
                  ),
                );
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vitals = buildVitals(l10n);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.healthTracking,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(
                    Icons.settings_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const AbnormalAlertWidget(),
              const SizedBox(height: 20),

              Text(
                l10n.recentEntries,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              RecentEntryWidget(
                entry: recentEntries.first,
                label: l10n.bloodPressure,
                color: const Color(0xFFE53935),
                icon: Icons.favorite_rounded,
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: vitals.map((v) => VitalCardWidget(vital: v)).toList(),
              ),
              const SizedBox(height: 20),

              Text(
                l10n.bloodPressureTrend,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const BpTrendChartWidget(),
              const SizedBox(height: 20),

              Text(
                l10n.healthInsights,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const HealthInsightsWidget(),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: openManualEntry,
                  icon: Icon(Icons.add_rounded, color: colorScheme.secondary),
                  label: Text(
                    l10n.addManualEntry,
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
  }
}
