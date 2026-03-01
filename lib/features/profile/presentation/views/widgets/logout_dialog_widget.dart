import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/utls/app_strings.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ─────────────────────────────
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: colorScheme.error,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            // ── Title ─────────────────────────────
            Text(
              AppStrings.confirmLogout,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // ── Subtitle ──────────────────────────
            Text(
              AppStrings.areYouSureLogout,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // ── Buttons ───────────────────────────
            Row(
              children: [
                // No
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppStrings.no,
                      style: textTheme.titleSmall,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Sure
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      CustomReplacementNavigation(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppStrings.sure,
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}