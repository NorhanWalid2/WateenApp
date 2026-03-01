import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/features/profile/presentation/views/widgets/profile_header_widget.dart';
import 'package:wateen_app/features/profile/presentation/views/widgets/profile_menu_item_widget.dart';
import 'package:wateen_app/features/profile/presentation/views/widgets/logout_dialog_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ────────────────────────────
              Text(AppStrings.profile, style: textTheme.headlineMedium),
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
                      title: AppStrings.familyMembers,
                      subtitle: AppStrings.manageFamilyAccounts,
                      onTap: () {
                        // TODO: navigate to family members
                      },
                    ),
                    Divider(height: 1, color: colorScheme.outline.withOpacity(0.4)),
                    ProfileMenuItemWidget(
                      icon: Icons.history_edu_outlined,
                      title: AppStrings.medicalHistory,
                      subtitle: AppStrings.viewAndUploadFiles,
                      onTap: () {
                        // TODO: navigate to medical history
                      },
                    ),
                    Divider(height: 1, color: colorScheme.outline.withOpacity(0.4)),
                    ProfileMenuItemWidget(
                      icon: Icons.settings_outlined,
                      title: AppStrings.settings,
                      subtitle: AppStrings.appPreferences,
                      onTap: () {
                        // TODO: navigate to settings
                      },
                    ),
                    Divider(height: 1, color: colorScheme.outline.withOpacity(0.4)),
                    ProfileMenuItemWidget(
                      icon: Icons.language_outlined,
                      title: AppStrings.language,
                      subtitle: AppStrings.englishArabic,
                      onTap: () {
                        // TODO: navigate to language settings
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Log Out Button ────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: Icon(
                    Icons.logout_rounded,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  label: Text(
                    AppStrings.logOut,
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
                  AppStrings.version,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const LogoutDialogWidget(),
    );
  }
}