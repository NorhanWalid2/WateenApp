import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/core/widgets/language_bottom_sheet.dart';
import 'package:wateen_app/features/patient/settings/presentation/views/widgets/settings_item_widget.dart';
import 'package:wateen_app/features/patient/settings/presentation/views/widgets/settings_section_widget.dart';
import 'package:wateen_app/features/patient/settings/presentation/views/widgets/settings_toggle_item_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _appointmentReminders = true;
  bool _biometricLogin = false;
  bool _twoFactorAuth = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardDecoration = BoxDecoration(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final divider = Divider(
      height: 1,
      color: colorScheme.outline.withOpacity(0.4),
    );

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
                    Text(l10n.settings, style: textTheme.headlineMedium),
                    const SizedBox(height: 24),

                    // ── Appearance ───────────────
                    SettingsSectionWidget(title: l10n.appearance),
                    const SizedBox(height: 8),
                    Container(
                      decoration: cardDecoration,
                      child: Column(
                        children: [
                          SettingsToggleItemWidget(
                            icon:
                                isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                            title: l10n.darkMode,
                            subtitle:
                                isDark ? l10n.darkModeOn : l10n.darkModeOff,
                            value: isDark,
                            onChanged:
                                (val) => context.read<ThemeCubit>().changeTheme(
                                  val ? 'dark' : 'light',
                                ),
                          ),
                          divider,
                          SettingsItemWidget(
                            icon: Icons.text_fields_rounded,
                            title: l10n.fontSize,
                            subtitle: l10n.fontSizeSubtitle,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Language ─────────────────
                    SettingsSectionWidget(title: l10n.language),
                    const SizedBox(height: 8),
                    Container(
                      decoration: cardDecoration,
                      child: SettingsItemWidget(
                        icon: Icons.language_rounded,
                        title: l10n.language,
                        subtitle: l10n.englishArabic,
                        onTap: () => LanguageBottomSheet.show(context),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Notifications ─────────────
                    SettingsSectionWidget(title: l10n.notifications),
                    const SizedBox(height: 8),
                    Container(
                      decoration: cardDecoration,
                      child: Column(
                        children: [
                          SettingsToggleItemWidget(
                            icon: Icons.notifications_outlined,
                            title: l10n.pushNotifications,
                            subtitle: l10n.pushNotificationsSubtitle,
                            value: _pushNotifications,
                            onChanged:
                                (val) =>
                                    setState(() => _pushNotifications = val),
                          ),
                          divider,
                          SettingsToggleItemWidget(
                            icon: Icons.email_outlined,
                            title: l10n.emailNotifications,
                            subtitle: l10n.emailNotificationsSubtitle,
                            value: _emailNotifications,
                            onChanged:
                                (val) =>
                                    setState(() => _emailNotifications = val),
                          ),
                          divider,
                          SettingsToggleItemWidget(
                            icon: Icons.calendar_today_outlined,
                            title: l10n.appointmentReminders,
                            subtitle: l10n.appointmentRemindersSubtitle,
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
                    SettingsSectionWidget(title: l10n.privacyAndSecurity),
                    const SizedBox(height: 8),
                    Container(
                      decoration: cardDecoration,
                      child: Column(
                        children: [
                          SettingsItemWidget(
                            icon: Icons.lock_outline_rounded,
                            title: l10n.changePassword,
                            subtitle: l10n.changePasswordSubtitle,
                            onTap: () => CustomNavigation(context, '/changePassword'),
                          ),

                          divider,
                          SettingsToggleItemWidget(
                            icon: Icons.fingerprint_rounded,
                            title: l10n.biometricLogin,
                            subtitle: l10n.biometricLoginSubtitle,
                            value: _biometricLogin,
                            onChanged:
                                (val) => setState(() => _biometricLogin = val),
                          ),
                          divider,
                          SettingsToggleItemWidget(
                            icon: Icons.verified_user_outlined,
                            title: l10n.twoFactorAuth,
                            subtitle: l10n.twoFactorAuthSubtitle,
                            value: _twoFactorAuth,
                            onChanged:
                                (val) => setState(() => _twoFactorAuth = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── About ─────────────────────
                    SettingsSectionWidget(title: l10n.about),
                    const SizedBox(height: 8),
                    Container(
                      decoration: cardDecoration,
                      child: Column(
                        children: [
                          SettingsItemWidget(
                            icon: Icons.info_outline_rounded,
                            title: l10n.appVersion,
                            subtitle: l10n.version,
                            showArrow: false,
                            onTap: () {},
                          ),
                          divider,
                          SettingsItemWidget(
                            icon: Icons.description_outlined,
                            title: l10n.termsOfService,
                            subtitle: l10n.termsSubtitle,
                            onTap: () {},
                          ),
                          divider,
                          SettingsItemWidget(
                            icon: Icons.privacy_tip_outlined,
                            title: l10n.privacyPolicy,
                            subtitle: l10n.privacySubtitle,
                            onTap: () {},
                          ),
                          divider,
                          SettingsItemWidget(
                            icon: Icons.star_outline_rounded,
                            title: l10n.rateTheApp,
                            subtitle: l10n.rateSubtitle,
                            onTap: () {},
                          ),
                          divider,
                          SettingsItemWidget(
                            icon: Icons.support_agent_outlined,
                            title: l10n.contactSupport,
                            subtitle: l10n.contactSupportSubtitle,
                            onTap: () {},
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
