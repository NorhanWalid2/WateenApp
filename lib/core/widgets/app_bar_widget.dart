import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: SvgPicture.asset(AppIcons.assetsIconsLogo, width: 35),
        ),
        const SizedBox(width: 12),
        Text(AppStrings.wateen, style: AppTextstyle.arimo24(context)),
      ],
    );
  }
}
