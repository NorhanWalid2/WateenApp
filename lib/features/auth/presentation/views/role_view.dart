import 'package:flutter/material.dart';
import 'package:wateen_app/core/enums/user_role.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/features/auth/data/model/role_model.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/auth_switch_text.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/selectable_role_card.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  int selectedIndex = -1;

  List<RoleData> _buildRoles(AppLocalizations l10n) => [
    RoleData(
      title: l10n.patient,
      subtitle: l10n.accesshealthservices,
      icon: AppIcons.assetsIconsPatient,
      role: UserRole.patient,
    ),
    RoleData(
      title: l10n.doctor,
      subtitle: l10n.managepatientcare,
      icon: AppIcons.assetsIconsDoctor,
      role: UserRole.doctor,
    ),
    RoleData(
      title: l10n.homeService,
      subtitle: l10n.providecareservices,
      icon: AppIcons.assetsIconsHomeService,
      role: UserRole.nurse,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final roles = _buildRoles(l10n);
    final bool hasSelection = selectedIndex != -1;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWidget(),
              const SizedBox(height: 32),

              Text(l10n.createAccount, style: textTheme.headlineLarge),
              const SizedBox(height: 4),
              Text(
                l10n.chooseyourrole,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 28),

              ...List.generate(roles.length, (i) {
                final role = roles[i];
                final bool isSelected = i == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = i),
                    child: SelectableRoleCard(
                      colorScheme: colorScheme,
                      isSelected: isSelected,
                      role: role,
                    ),
                  ),
                );
              }),

              const Spacer(),

              // ── Create Account Button ─────────────
              CustomButton(
                title: l10n.createAccount,
                onTap:
                    hasSelection
                        ? () => CustomNavigation(
                          context,
                          '/signup',
                          extra: roles[selectedIndex].role,
                        )
                        : null,
                color:
                    hasSelection ? colorScheme.secondary : colorScheme.outline,
                colorText:
                    hasSelection
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
              ),

              const SizedBox(height: 16),

              // ── Sign In Link ──────────────────────
              AuthSwitchText(
                colorScheme: colorScheme,
                firstText: l10n.alreadyhaveanaccount,
                secondText: l10n.signIn,
                onTap: () => CustomReplacementNavigation(context, '/login'),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
