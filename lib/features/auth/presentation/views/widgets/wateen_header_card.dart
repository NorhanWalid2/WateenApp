import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';

class WateenHeaderCard extends StatelessWidget {
  final String subtitle;
  const WateenHeaderCard({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.assetsIconsLogo, height: 40),
          const SizedBox(width: 16),
          Text(subtitle, style: AppTextstyle.archivo15w400Gray(context)),
        ],
      ),
    );
  }
}
