import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';
import 'package:wateen_app/features/patient/profile/presentation/cubit/profile_cubit.dart';
import 'package:wateen_app/features/patient/profile/presentation/cubit/profile_state.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/edit_profile_sheet.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/logout_dialog_widget.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/profile_header_card_widget.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/profile_info_card_widget.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/widgets/profile_menu_item_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..fetchPatientProfile(),
      child: const ProfileViewBody(),
    );
  }
}

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  void showEditSheet(BuildContext context, PatientProfileModel? profile) {
    if (profile == null) return;
    final cubit = context.read<ProfileCubit>(); // ✅ capture before sheet opens
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileSheet(
        profile: profile,
        cubit: cubit, // ✅ pass directly — no BlocProvider needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ));
        } else if (state is ProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ));
        }
      },
      builder: (context, state) {
        PatientProfileModel? profile;
        if (state is ProfileLoaded) profile = state.profile;
        if (state is ProfileUpdating) profile = state.profile;
        if (state is ProfileUpdateSuccess) profile = state.profile;
        if (state is ProfileUpdateError) profile = state.profile;

        final isLoading = state is ProfileLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.profile, style: textTheme.headlineMedium),
              const SizedBox(height: 20),

              // ── Header Card ──────────────────────────────────────
              ProfileHeaderCardWidget(
                profile: profile,
                isLoading: isLoading,
                onEditTap: () => showEditSheet(context, profile),
              ),

              const SizedBox(height: 24),

              // ── Personal Info ────────────────────────────────────
              if (profile != null) ...[
                ProfileInfoCardWidget(profile: profile),
                const SizedBox(height: 24),
              ],

              // ── Menu ─────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                    Divider(
                        height: 1,
                        color: colorScheme.outline.withOpacity(0.4)),
                    ProfileMenuItemWidget(
                      icon: Icons.history_edu_outlined,
                      title: l10n.medicalHistory,
                      subtitle: l10n.viewAndUploadFiles,
                      onTap: () {},
                    ),
                    Divider(
                        height: 1,
                        color: colorScheme.outline.withOpacity(0.4)),
                    ProfileMenuItemWidget(
                      icon: Icons.settings_outlined,
                      title: l10n.settings,
                      subtitle: l10n.appPreferences,
                      onTap: () => CustomNavigation(context, '/settings'),
                    ),
                    Divider(
                        height: 1,
                        color: colorScheme.outline.withOpacity(0.4)),
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

              // ── Logout ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const LogoutDialogWidget(),
                  ),
                  icon: Icon(Icons.logout_rounded,
                      color: colorScheme.error, size: 20),
                  label: Text(
                    l10n.logOut,
                    style: TextStyle(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: colorScheme.error, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  l10n.version,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}