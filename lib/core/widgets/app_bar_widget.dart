import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';
import 'package:wateen_app/core/theming/theme_toggle.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final canPop = context.canPop();

    return Row(
      children: [
        // ── Back Button ──────────────────────
        if (canPop)
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),

        if (canPop) const SizedBox(width: 12),

        // ── Logo ─────────────────────────────
        SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
        const SizedBox(width: 8),

        // ── App Name ─────────────────────────
        Text(l10n.wateen, style: textTheme.titleLarge),

        // // ── Theme Toggle ─────────────────────
        // ThemeToggle(
        //   onThemeChanged:
        //       (mode) => context.read<ThemeCubit>().changeTheme(mode),
        // ),
      ],
    );
  }
}
