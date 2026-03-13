import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/features/patient/home/data/models/quick_action_model.dart';
import 'package:wateen_app/features/patient/home/presentation/views/widgets/quick_action_card_widget.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  List<QuickActionModel> buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      QuickActionModel(
        icon: Icons.calendar_today_rounded,
        label: l10n.myAppointments,
        subtitle: l10n.viewAndManage,
        color: Colors.blue,
        onTap: () => CustomNavigation(context, '/appointments'),
      ),
      QuickActionModel(
        icon: Icons.local_hospital_rounded,
        label: l10n.bookDoctor,
        subtitle: l10n.scheduleAppointment,
        color: Colors.green,
        onTap: () => CustomNavigation(context, '/bookAppointment'),
      ),
      QuickActionModel(
        icon: Icons.medical_services_rounded,
        label: l10n.requestNurse,
        subtitle: l10n.homeCareService,
        color: Colors.purple,
        onTap: () => CustomNavigation(context, '/requestNurse'),
      ),
      QuickActionModel(
        icon: Icons.restaurant_rounded,
        label: l10n.scanMeal,
        subtitle: l10n.checkNutrition,
        color: Colors.orange,
        onTap: () {},
      ),
      QuickActionModel(
        icon: Icons.monitor_heart_rounded,
        label: l10n.addVitals,
        subtitle: l10n.logHealthData,
        color: Colors.red,
        onTap: () => CustomNavigation(context, '/addVitals'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final actions = buildActions(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children:
          actions
              .map((action) => QuickActionCardWidget(action: action))
              .toList(),
    );
  }
}
