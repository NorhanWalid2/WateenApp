import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/settings_section_widget.dart';
import 'widgets/settings_toggle_item_widget.dart';
import 'widgets/settings_info_item_widget.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  // ── Notification toggles ──
  bool _emailNotifications = true;
  bool _newRegistrationAlerts = true;
  bool _appointmentReminders = true;
  bool _systemUpdates = false;

  // ── Security toggles ──
  bool _twoFactorAuth = true;
  bool _passwordExpiry = false;
  bool _sessionTimeout = true;

  // ── User Management toggles ──
  bool _autoApprovePatients = true;
  bool _manualDoctorVerification = true;
  bool _manualHomeServiceVerification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Wateen',
                      style: GoogleFonts.archivo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
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

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Settings',
                      style: GoogleFonts.archivo(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage system settings and configurations',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── General Settings ──
                    SettingsSectionWidget(
                      icon: Icons.language_rounded,
                      title: 'General Settings',
                      children: [
                        SettingsInfoItemWidget(
                          title: 'System Name',
                          subtitle: 'The name displayed across the platform',
                          value: 'Wateen Healthcare',
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          thickness: 1,
                          height: 1,
                        ),
                        SettingsInfoItemWidget(
                          title: 'Default Language',
                          subtitle: 'System default language',
                          value: 'English',
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          thickness: 1,
                          height: 1,
                        ),
                        SettingsInfoItemWidget(
                          title: 'Time Zone',
                          subtitle: 'Default timezone for the system',
                          value: 'UTC+4 (Dubai)',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Notification Settings ──
                    SettingsSectionWidget(
                      icon: Icons.notifications_rounded,
                      title: 'Notification Settings',
                      children: [
                        SettingsToggleItemWidget(
                          title: 'Email Notifications',
                          subtitle:
                              'Send email notifications to administrators',
                          value: _emailNotifications,
                          onChanged:
                              (val) =>
                                  setState(() => _emailNotifications = val),
                        ),
                        SettingsToggleItemWidget(
                          title: 'New Registration Alerts',
                          subtitle: 'Alert when new users register',
                          value: _newRegistrationAlerts,
                          onChanged:
                              (val) =>
                                  setState(() => _newRegistrationAlerts = val),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Appointment Reminders',
                          subtitle: 'Send appointment reminders to patients',
                          value: _appointmentReminders,
                          onChanged:
                              (val) =>
                                  setState(() => _appointmentReminders = val),
                        ),
                        SettingsToggleItemWidget(
                          title: 'System Updates',
                          subtitle:
                              'Notify about system updates and maintenance',
                          value: _systemUpdates,
                          onChanged:
                              (val) => setState(() => _systemUpdates = val),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Security Settings ──
                    SettingsSectionWidget(
                      icon: Icons.shield_rounded,
                      title: 'Security Settings',
                      children: [
                        SettingsToggleItemWidget(
                          title: 'Two-Factor Authentication',
                          subtitle: 'Require 2FA for admin accounts',
                          value: _twoFactorAuth,
                          onChanged:
                              (val) => setState(() => _twoFactorAuth = val),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Password Expiry',
                          subtitle: 'Require password change every 90 days',
                          value: _passwordExpiry,
                          onChanged:
                              (val) => setState(() => _passwordExpiry = val),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Session Timeout',
                          subtitle:
                              'Auto logout after 30 minutes of inactivity',
                          value: _sessionTimeout,
                          onChanged:
                              (val) => setState(() => _sessionTimeout = val),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── User Management ──
                    SettingsSectionWidget(
                      icon: Icons.manage_accounts_rounded,
                      title: 'User Management',
                      children: [
                        SettingsToggleItemWidget(
                          title: 'Auto-Approve Patients',
                          subtitle:
                              'Automatically approve patient registrations',
                          value: _autoApprovePatients,
                          onChanged:
                              (val) =>
                                  setState(() => _autoApprovePatients = val),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Manual Doctor Verification',
                          subtitle:
                              'Require manual verification for doctor accounts',
                          value: _manualDoctorVerification,
                          onChanged:
                              (val) => setState(
                                () => _manualDoctorVerification = val,
                              ),
                        ),
                        SettingsToggleItemWidget(
                          title: 'Manual Home Service Verification',
                          subtitle:
                              'Require manual verification for home service providers',
                          value: _manualHomeServiceVerification,
                          onChanged:
                              (val) => setState(
                                () => _manualHomeServiceVerification = val,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Email Settings ──
                    SettingsSectionWidget(
                      icon: Icons.email_rounded,
                      title: 'Email Settings',
                      children: [
                        SettingsInfoItemWidget(
                          title: 'SMTP Server',
                          subtitle: 'Email server configuration',
                          value: 'smtp.wateen.health',
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          thickness: 1,
                          height: 1,
                        ),
                        SettingsInfoItemWidget(
                          title: 'From Email',
                          subtitle: 'Default sender email address',
                          value: 'noreply@wateen.health',
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          thickness: 1,
                          height: 1,
                        ),
                        SettingsInfoItemWidget(
                          title: 'Support Email',
                          subtitle: 'Email for support inquiries',
                          value: 'support@wateen.health',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Database & Backup ──
                    SettingsSectionWidget(
                      icon: Icons.storage_rounded,
                      title: 'Database & Backup',
                      children: [
                        SettingsInfoItemWidget(
                          title: 'Database Status',
                          subtitle: 'Current database connection status',
                          value: 'Connected',
                          valueColor: const Color(0xFF16A34A),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          thickness: 1,
                          height: 1,
                        ),
                        SettingsInfoItemWidget(
                          title: 'Last Backup',
                          subtitle: 'Most recent backup time',
                          value: '2024-01-26 02:00 AM',
                        ),
                        const SizedBox(height: 12),

                        // Create Backup button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: connect backup API
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Backup started successfully!',
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Create Backup Now',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
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
