import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/features/settings/presentation/views/widgets/settings_item_widget.dart';
import 'package:wateen_app/features/settings/presentation/views/widgets/settings_section_widget.dart';
import 'package:wateen_app/features/settings/presentation/views/widgets/settings_toggle_item_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // ── Notifications ─────────────────────────────
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _appointmentReminders = true;

  // ── Privacy & Security ────────────────────────
  bool _biometricLogin = false;
  bool _twoFactorAuth = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: AppBarWidget(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.settings, style: textTheme.headlineMedium),
                    const SizedBox(height: 24),

                    // ── Appearance ───────────────
                    SettingsSectionWidget(title: AppStrings.appearance),
                    const SizedBox(height: 8),
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
                          SettingsToggleItemWidget(
                            icon:
                                isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                            title: AppStrings.darkMode,
                            subtitle:
                                isDark
                                    ? AppStrings.darkModeOn
                                    : AppStrings.darkModeOff,
                            value: isDark,
                            onChanged: (val) {
                              context.read<ThemeCubit>().changeTheme(
                                val ? 'dark' : 'light',
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsItemWidget(
                            icon: Icons.text_fields_rounded,
                            title: AppStrings.fontSize,
                            subtitle: AppStrings.fontSizeSubtitle,
                            onTap: () {
                              // TODO: font size picker
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Language ─────────────────
                    SettingsSectionWidget(title: AppStrings.language),
                    const SizedBox(height: 8),
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
                      child: SettingsItemWidget(
                        icon: Icons.language_rounded,
                        title: AppStrings.language,
                        subtitle: AppStrings.englishArabic,
                        onTap: () {
                          // TODO: language picker
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Notifications ─────────────
                    SettingsSectionWidget(title: AppStrings.notifications),
                    const SizedBox(height: 8),
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
                          SettingsToggleItemWidget(
                            icon: Icons.notifications_outlined,
                            title: AppStrings.pushNotifications,
                            subtitle: AppStrings.pushNotificationsSubtitle,
                            value: _pushNotifications,
                            onChanged:
                                (val) =>
                                    setState(() => _pushNotifications = val),
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsToggleItemWidget(
                            icon: Icons.email_outlined,
                            title: AppStrings.emailNotifications,
                            subtitle: AppStrings.emailNotificationsSubtitle,
                            value: _emailNotifications,
                            onChanged:
                                (val) =>
                                    setState(() => _emailNotifications = val),
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsToggleItemWidget(
                            icon: Icons.calendar_today_outlined,
                            title: AppStrings.appointmentReminders,
                            subtitle: AppStrings.appointmentRemindersSubtitle,
                            value: _appointmentReminders,
                            onChanged:
                                (val) =>
                                    setState(() => _appointmentReminders = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Privacy & Security ────────
                    SettingsSectionWidget(title: AppStrings.privacyAndSecurity),
                    const SizedBox(height: 8),
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
                          SettingsItemWidget(
                            icon: Icons.lock_outline_rounded,
                            title: AppStrings.changePassword,
                            subtitle: AppStrings.changePasswordSubtitle,
                            onTap: () {
                              // TODO: change password
                            },
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsToggleItemWidget(
                            icon: Icons.fingerprint_rounded,
                            title: AppStrings.biometricLogin,
                            subtitle: AppStrings.biometricLoginSubtitle,
                            value: _biometricLogin,
                            onChanged:
                                (val) => setState(() => _biometricLogin = val),
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsToggleItemWidget(
                            icon: Icons.verified_user_outlined,
                            title: AppStrings.twoFactorAuth,
                            subtitle: AppStrings.twoFactorAuthSubtitle,
                            value: _twoFactorAuth,
                            onChanged:
                                (val) => setState(() => _twoFactorAuth = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── About ─────────────────────
                    SettingsSectionWidget(title: AppStrings.about),
                    const SizedBox(height: 8),
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
                          SettingsItemWidget(
                            icon: Icons.info_outline_rounded,
                            title: AppStrings.appVersion,
                            subtitle: AppStrings.version,
                            showArrow: false,
                            onTap: () {},
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsItemWidget(
                            icon: Icons.description_outlined,
                            title: AppStrings.termsOfService,
                            subtitle: AppStrings.termsSubtitle,
                            onTap: () {
                              // TODO: open terms
                            },
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsItemWidget(
                            icon: Icons.privacy_tip_outlined,
                            title: AppStrings.privacyPolicy,
                            subtitle: AppStrings.privacySubtitle,
                            onTap: () {
                              // TODO: open privacy
                            },
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsItemWidget(
                            icon: Icons.star_outline_rounded,
                            title: AppStrings.rateTheApp,
                            subtitle: AppStrings.rateSubtitle,
                            onTap: () {
                              // TODO: open store
                            },
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.4),
                          ),
                          SettingsItemWidget(
                            icon: Icons.support_agent_outlined,
                            title: AppStrings.contactSupport,
                            subtitle: AppStrings.contactSupportSubtitle,
                            onTap: () {
                              // TODO: contact support
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
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
