import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/profile_header_widget.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/profile_menu_item_widget.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/logout_dialog_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ────────────────────────────
          Text(l10n.profile, style: textTheme.headlineMedium),
          const SizedBox(height: 16),

          // ── Profile Header Card ───────────────
          const ProfileHeaderWidget(
            name: 'Ahmed Al-Mansouri',
            email: 'ahmed.mansouri@email.com',
            userId: 'ID: WAT-12345',
          ),

          const SizedBox(height: 24),

          // ── Menu Items ────────────────────────
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ProfileMenuItemWidget(
                  icon: Icons.people_outline_rounded,
                  title: l10n.familyMembers,
                  subtitle: l10n.manageFamilyAccounts,
                  onTap: () {},
                ),
                Divider(height: 1, color: colorScheme.outline.withOpacity(0.4)),
                ProfileMenuItemWidget(
                  icon: Icons.history_edu_outlined,
                  title: l10n.medicalHistory,
                  subtitle: l10n.viewAndUploadFiles,
                  onTap: () {},
                ),
                Divider(height: 1, color: colorScheme.outline.withOpacity(0.4)),
                ProfileMenuItemWidget(
                  icon: Icons.settings_outlined,
                  title: l10n.settings,
                  subtitle: l10n.appPreferences,
                  onTap: () => CustomNavigation(context, '/settings'),
                ),
                Divider(height: 1, color: colorScheme.outline.withOpacity(0.4)),
                ProfileMenuItemWidget(
                  icon: Icons.language_outlined,
                  title: l10n.language,
                  subtitle: l10n.englishArabic,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Log Out Button ────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  () => showDialog(
                    context: context,
                    builder: (ctx) => const LogoutDialogWidget(),
                  ),
              icon: Icon(
                Icons.logout_rounded,
                color: colorScheme.error,
                size: 20,
              ),
              label: Text(
                l10n.logOut,
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: colorScheme.error, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Version ───────────────────────────
          Center(
            child: Text(
              l10n.version,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
