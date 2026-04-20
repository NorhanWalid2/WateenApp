import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/admin_top_bar_widget.dart';
 
class PatientsManagementView extends StatelessWidget {
  const PatientsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
          Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Wateen Logo
                  
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.assetsIconsLogo, width: 32),
                              const SizedBox(width: 8),
                      
                              // ── App Name ─────────────────────────
                              Text( 'Wateen', style: textTheme.titleLarge),
                    ],
                  ),

                  // Hamburger menu
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline_rounded,
                        size: 56, color: colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text('Patient Management',
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      'Coming soon',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}