import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/enums/user_role.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';
import 'package:wateen_app/core/theming/theme_toggle.dart';
import 'package:wateen_app/core/utls/app_assets.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/choose_role_widget.dart';

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        actions: [
          ThemeToggle(
            onThemeChanged:
                (mode) => context.read<ThemeCubit>().changeTheme(mode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Assets.assetsImagesLogo),
            const SizedBox(height: 13),
            Text(
              'Welcome to Wateen',
              style: AppTextstyle.archivo25w700(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your role to continue',
              style: AppTextstyle.archivo15w400(context),
            ),
            const SizedBox(height: 47),
            ChooseRoleWidget(
              index: 0,
              leading: Image.asset(Assets.assetsImagesContainer),
              roleTitle: 'Doctor',
              subTitleRole: 'Continue as doctor',
              selectedIndex: selectedIndex,
              onTap: () {
                setState(() => selectedIndex = 0);
                CustomNavigation(context, '/signup', extra: UserRole.doctor);
              },
            ),
            const SizedBox(height: 16),
            ChooseRoleWidget(
              index: 1,
              leading: Image.asset(Assets.assetsImagesNurse),
              roleTitle: 'Nurse',
              subTitleRole: 'Continue as nurse',
              selectedIndex: selectedIndex,
              onTap: () {
                setState(() => selectedIndex = 1);
                CustomNavigation(context, '/signup', extra: UserRole.nurse);
              },
            ),
            const SizedBox(height: 16),
            ChooseRoleWidget(
              index: 2,
              leading: Image.asset(Assets.assetsImagesPatient),
              roleTitle: 'Patient',
              subTitleRole: 'Continue as patient',
              selectedIndex: selectedIndex,
              onTap: () {
                setState(() => selectedIndex = 2);
                CustomNavigation(context, '/signup', extra: UserRole.patient);
              },
            ),
            const SizedBox(height: 47),
            Text(
              'Secure • Trusted • Professional',
              style: AppTextstyle.archivo15w400(context),
            ),
          ],
        ),
      ),
    );
  }
}
