import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/utls/app_assets.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';

class appBarWidget extends StatelessWidget {
  const appBarWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: SvgPicture.asset(Assets.assetsImagesBack, width: 12),
        ),
        const SizedBox(width: 20),
        Text(title, style: AppTextstyle.archivo20),
      ],
    );
  }
}
