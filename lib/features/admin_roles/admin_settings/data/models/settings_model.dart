class AdminSettingsModel {
  // General
  final String systemName;
  final String defaultLanguage;
  final String timeZone;

  // Notifications
  final bool emailNotifications;
  final bool newRegistrationAlerts;
  final bool appointmentReminders;
  final bool systemUpdates;

  // Security
  final bool twoFactorAuth;
  final bool passwordExpiry;
  final bool sessionTimeout;

  // User Management
  final bool autoApprovePatients;
  final bool manualDoctorVerification;
  final bool manualHomeServiceVerification;

  // Email
  final String smtpServer;
  final String fromEmail;
  final String supportEmail;

  // Database
  final String databaseStatus;
  final String lastBackup;

  AdminSettingsModel({
    required this.systemName,
    required this.defaultLanguage,
    required this.timeZone,
    required this.emailNotifications,
    required this.newRegistrationAlerts,
    required this.appointmentReminders,
    required this.systemUpdates,
    required this.twoFactorAuth,
    required this.passwordExpiry,
    required this.sessionTimeout,
    required this.autoApprovePatients,
    required this.manualDoctorVerification,
    required this.manualHomeServiceVerification,
    required this.smtpServer,
    required this.fromEmail,
    required this.supportEmail,
    required this.databaseStatus,
    required this.lastBackup,
  });
}
