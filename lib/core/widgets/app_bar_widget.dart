import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';
import 'package:wateen_app/core/theming/theme_toggle.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/utls/app_strings.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: SvgPicture.asset(AppIcons.assetsIconsLogo, width: 35),
        ),
        const SizedBox(width: 12),
        Text(AppStrings.wateen, style: textTheme.displayLarge),
        Spacer(),
        ThemeToggle(
          onThemeChanged:
              (mode) => context.read<ThemeCubit>().changeTheme(mode),
        ),
      ],
    );
  }
}
