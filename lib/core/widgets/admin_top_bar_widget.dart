import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminTopBarWidget extends StatelessWidget {
  const AdminTopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Logo ─────────────────────────────────────────────
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  colorScheme.secondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Wateen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.inverseSurface,
                ),
              ),
            ],
          ),

          // ── Menu ─────────────────────────────────────────────
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
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