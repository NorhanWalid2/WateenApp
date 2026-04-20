import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/core/utls/app_icons.dart';
import 'package:wateen_app/core/widgets/admin_top_bar_widget.dart';
import 'package:wateen_app/features/admin_roles/layout/admin_main_layout.dart';
import 'widgets/settings_section_widget.dart';
import 'widgets/settings_toggle_item_widget.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => AdminSettingsViewState();
}

class AdminSettingsViewState extends State<AdminSettingsView> {
  bool emailNotifications = true;
  bool newRegistrationAlerts = true;
  bool appointmentReminders = true;
  bool systemUpdates = false;
  bool twoFactorAuth = true;
  bool passwordExpiry = false;
  bool sessionTimeout = true;
  bool autoApprovePatients = true;
  bool manualDoctorVerification = true;
  bool manualHomeServiceVerification = true;

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
                      Text('Wateen', style: textTheme.titleLarge),
                    ],
                  ),

                  // Hamburger menu
                  GestureDetector(
                    onTap: () {
                      // Find the AdminMainLayout's scaffold key and open drawer
                      final layoutState =
                          context
                              .findAncestorStateOfType<AdminMainLayoutState>();
                      layoutState?.scaffoldKey.currentState?.openDrawer();
                    },
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage system settings and configurations',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    SettingsSectionWidget(
                      icon: Icons.notifications_rounded,
                      title: 'Notification Settings',
                      children: [
                        SettingsToggleItemWidget(
                          title: 'Email Notifications',
                          subtitle:
                              'Send email notifications to administrators',
                          value: emailNotifications,
                          onChanged:
                              (v) => setState(() => emailNotifications = v),
                        ),
                        SettingsToggleItemWidget(
                          title: 'New Registration Alerts',
                          subtitle: 'Alert when new users register',
                          value: newRegistrationAlerts,
                          onChanged:
                              (v) => setState(() => newRegistrationAlerts = v),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Appointment Reminders',
                          subtitle: 'Send appointment reminders to patients',
                          value: appointmentReminders,
                          onChanged:
                              (v) => setState(() => appointmentReminders = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SettingsSectionWidget(
                      icon: Icons.shield_rounded,
                      title: 'Security Settings',
                      children: [
                        SettingsToggleItemWidget(
                          title: 'Two-Factor Authentication',
                          subtitle: 'Require 2FA for admin accounts',
                          value: twoFactorAuth,
                          onChanged: (v) => setState(() => twoFactorAuth = v),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Session Timeout',
                          subtitle:
                              'Auto logout after 30 minutes of inactivity',
                          value: sessionTimeout,
                          onChanged: (v) => setState(() => sessionTimeout = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SettingsSectionWidget(
                      icon: Icons.manage_accounts_rounded,
                      title: 'User Management',
                      children: [
                        SettingsToggleItemWidget(
                          title: 'Auto-Approve Patients',
                          subtitle:
                              'Automatically approve patient registrations',
                          value: autoApprovePatients,
                          onChanged:
                              (v) => setState(() => autoApprovePatients = v),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Manual Doctor Verification',
                          subtitle: 'Require manual verification for doctors',
                          value: manualDoctorVerification,
                          onChanged:
                              (v) =>
                                  setState(() => manualDoctorVerification = v),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Manual Home Service Verification',
                          subtitle: 'Require manual verification for nurses',
                          value: manualHomeServiceVerification,
                          onChanged:
                              (v) => setState(
                                () => manualHomeServiceVerification = v,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
