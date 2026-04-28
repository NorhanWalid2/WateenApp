import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';

class NurseTopBarWidget extends StatelessWidget {
  final VoidCallback onMenuTap;

  const NurseTopBarWidget({
    super.key,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
              const SizedBox(width: 8),
              Text('Wateen', style: textTheme.titleLarge),
            ],
          ),
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.menu_rounded,
                color: colorScheme.inverseSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}