import 'package:flutter/material.dart';
import 'package:wateen_app/core/enums/user_role.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/features/auth/data/model/role_model.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/auth_switch_text.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/selectable_role_card.dart';

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  int selectedIndex = -1;

  final List<RoleData> _roles = [
    RoleData(
      title: AppStrings.patient,
      subtitle: AppStrings.accesshealthservices,
      icon: AppIcons.assetsIconsPatient,
      role: UserRole.patient,
    ),
    RoleData(
      title: AppStrings.doctor,
      subtitle: AppStrings.managepatientcare,
      icon: AppIcons.assetsIconsDoctor,
      role: UserRole.doctor,
    ),
    RoleData(
      title: AppStrings.homeService,
      subtitle: AppStrings.providecareservices,
      icon: AppIcons.assetsIconsHomeService,
      role: UserRole.nurse,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              Text(
                AppStrings.createAccount,
                style: AppTextstyle.arimo30(context),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.chooseyourrole,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.outlineVariant,
                ),
              ),

              const SizedBox(height: 28),

              ...List.generate(_roles.length, (i) {
                final role = _roles[i];
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

              // Create Account button
              CustomButton(
                onTap:
                    hasSelection
                        ? () => CustomNavigation(
                          context,
                          '/signup',
                          extra: _roles[selectedIndex].role,
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

              // Sign in link
              AuthSwitchText(
                colorScheme: colorScheme,
                firstText: AppStrings.alreadyhaveanaccount,
                secondText: AppStrings.signIn,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
