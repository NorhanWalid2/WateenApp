import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Wateen'**
  String get appName;

  /// No description provided for @aIHealthAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Health Assistant'**
  String get aIHealthAssistant;

  /// No description provided for @getInstantMedical.
  ///
  /// In en, this message translates to:
  /// **'Get instant medical guidance powered by artificial intelligence 24/7'**
  String get getInstantMedical;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @expertDoctors.
  ///
  /// In en, this message translates to:
  /// **'Expert Doctors'**
  String get expertDoctors;

  /// No description provided for @connectWithCertified.
  ///
  /// In en, this message translates to:
  /// **'Connect with certified healthcare professionals through video consultations'**
  String get connectWithCertified;

  /// No description provided for @homeCareServices.
  ///
  /// In en, this message translates to:
  /// **'Home Care Services'**
  String get homeCareServices;

  /// No description provided for @requestProfessionalNursing.
  ///
  /// In en, this message translates to:
  /// **'Request professional nursing and physiotherapy services at your doorstep'**
  String get requestProfessionalNursing;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @wateen.
  ///
  /// In en, this message translates to:
  /// **'Wateen'**
  String get wateen;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInTo.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your account'**
  String get signInTo;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enteryouremail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enteryouremail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enteryourpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enteryourpassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// No description provided for @doNotHave.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get doNotHave;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get byContinuing;

  /// No description provided for @termsofServiceandPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **' Terms of Service and Privacy Policy'**
  String get termsofServiceandPrivacyPolicy;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @chooseyourrole.
  ///
  /// In en, this message translates to:
  /// **'Choose your role to get started'**
  String get chooseyourrole;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @accesshealthservices.
  ///
  /// In en, this message translates to:
  /// **'Access health services'**
  String get accesshealthservices;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @managepatientcare.
  ///
  /// In en, this message translates to:
  /// **'Manage patient care'**
  String get managepatientcare;

  /// No description provided for @homeService.
  ///
  /// In en, this message translates to:
  /// **'Home Service'**
  String get homeService;

  /// No description provided for @providecareservices.
  ///
  /// In en, this message translates to:
  /// **'Provide care services'**
  String get providecareservices;

  /// No description provided for @alreadyhaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyhaveanaccount;

  /// No description provided for @patientRegistration.
  ///
  /// In en, this message translates to:
  /// **'Patient Registration'**
  String get patientRegistration;

  /// No description provided for @createyouraccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account to access healthcare services'**
  String get createyouraccount;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enteryourfullname.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enteryourfullname;

  /// No description provided for @youremailexample.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get youremailexample;

  /// No description provided for @createApassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createApassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmyourpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmyourpassword;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @numberExample.
  ///
  /// In en, this message translates to:
  /// **'+966 5x xxx xxxx'**
  String get numberExample;

  /// No description provided for @dateofBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateofBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @nationalID.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalID;

  /// No description provided for @enteryournationalID.
  ///
  /// In en, this message translates to:
  /// **'Enter your national ID'**
  String get enteryournationalID;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @fullnameofemergencycontact.
  ///
  /// In en, this message translates to:
  /// **'Full name of emergency contact'**
  String get fullnameofemergencycontact;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// No description provided for @createPatientAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Patient Account'**
  String get createPatientAccount;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @byCreatingAnAccount.
  ///
  /// In en, this message translates to:
  /// **' By creating an account, you agree to our and'**
  String get byCreatingAnAccount;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @doctorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Doctor Registration'**
  String get doctorRegistration;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @medicalLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'Medical License Number'**
  String get medicalLicenseNumber;

  /// No description provided for @enterLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter license number'**
  String get enterLicenseNumber;

  /// No description provided for @yearsofExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsofExperience;

  /// No description provided for @hospitalClinicAffiliation.
  ///
  /// In en, this message translates to:
  /// **'Hospital/Clinic Affiliation'**
  String get hospitalClinicAffiliation;

  /// No description provided for @currentWorkplace.
  ///
  /// In en, this message translates to:
  /// **'Current workplace'**
  String get currentWorkplace;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee (SAR)'**
  String get consultationFee;

  /// No description provided for @availableForHomeVisits.
  ///
  /// In en, this message translates to:
  /// **'Available for Home Visits'**
  String get availableForHomeVisits;

  /// No description provided for @checkThisIfYou.
  ///
  /// In en, this message translates to:
  /// **'Check this if you provide home visit services'**
  String get checkThisIfYou;

  /// No description provided for @uploadMedicalLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload Medical License'**
  String get uploadMedicalLicense;

  /// No description provided for @uploadAClearPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo or scan of your medical license. We\'ll verify it using OCR technology.'**
  String get uploadAClearPhoto;

  /// No description provided for @uploadLicenseDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload License Document'**
  String get uploadLicenseDocument;

  /// No description provided for @jPGPNGOrPDF.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or PDF (max 10MB)'**
  String get jPGPNGOrPDF;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @yourAccountWillBe.
  ///
  /// In en, this message translates to:
  /// **'Note: Your account will be under review by our admin team. You\'ll be notified once approved.'**
  String get yourAccountWillBe;

  /// No description provided for @submitRegistration.
  ///
  /// In en, this message translates to:
  /// **'Submit Registration'**
  String get submitRegistration;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @selectYourServiceType.
  ///
  /// In en, this message translates to:
  /// **'Select your service type'**
  String get selectYourServiceType;

  /// No description provided for @reviewYourInformation.
  ///
  /// In en, this message translates to:
  /// **'Review Your Information'**
  String get reviewYourInformation;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @professionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Professional Details'**
  String get professionalDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name :'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email :'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone :'**
  String get phone;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number :'**
  String get licenseNumber;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience :'**
  String get experience;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital :'**
  String get hospital;

  /// No description provided for @licenseStatus.
  ///
  /// In en, this message translates to:
  /// **'License Status'**
  String get licenseStatus;

  /// No description provided for @licenseVerified.
  ///
  /// In en, this message translates to:
  /// **'License Verified via OCR'**
  String get licenseVerified;

  /// No description provided for @noLicenseUploaded.
  ///
  /// In en, this message translates to:
  /// **'No License Uploaded'**
  String get noLicenseUploaded;

  /// No description provided for @bySubmittingThis.
  ///
  /// In en, this message translates to:
  /// **'By submitting this registration, you confirm that all information provided is accurate and you agree to our '**
  String get bySubmittingThis;

  /// No description provided for @drFullName.
  ///
  /// In en, this message translates to:
  /// **'Dr. Full Name'**
  String get drFullName;

  /// No description provided for @doctorHospital.
  ///
  /// In en, this message translates to:
  /// **'doctor@hospital.com'**
  String get doctorHospital;

  /// No description provided for @createSecurePassword.
  ///
  /// In en, this message translates to:
  /// **'Create a secure password'**
  String get createSecurePassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a verification code to reset your password'**
  String get enterYourEmail;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @theVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code will be sent to your registered email address and will expire in 10 minutes.'**
  String get theVerificationCode;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @weSentA6Digit.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to'**
  String get weSentA6Digit;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCode;

  /// No description provided for @wrongEmail.
  ///
  /// In en, this message translates to:
  /// **'Wrong email?'**
  String get wrongEmail;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @manageFamilyAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage family accounts'**
  String get manageFamilyAccounts;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @viewAndUploadFiles.
  ///
  /// In en, this message translates to:
  /// **'View and upload files'**
  String get viewAndUploadFiles;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get appPreferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @englishArabic.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishArabic;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @sure.
  ///
  /// In en, this message translates to:
  /// **'Sure'**
  String get sure;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeOn.
  ///
  /// In en, this message translates to:
  /// **'Dark theme is active'**
  String get darkModeOn;

  /// No description provided for @darkModeOff.
  ///
  /// In en, this message translates to:
  /// **'Light theme is active'**
  String get darkModeOff;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @fontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust text size'**
  String get fontSizeSubtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive app notifications'**
  String get pushNotificationsSubtitle;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive updates via email'**
  String get emailNotificationsSubtitle;

  /// No description provided for @appointmentReminders.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminders'**
  String get appointmentReminders;

  /// No description provided for @appointmentRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminded before appointments'**
  String get appointmentRemindersSubtitle;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get changePasswordSubtitle;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @biometricLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID or Fingerprint'**
  String get biometricLoginSubtitle;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @twoFactorAuthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add extra security to your account'**
  String get twoFactorAuthSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @termsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our terms'**
  String get termsSubtitle;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacySubtitle;

  /// No description provided for @rateTheApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateTheApp;

  /// No description provided for @rateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Leave us a review'**
  String get rateSubtitle;

  /// No description provided for @contactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help from our team'**
  String get contactSupportSubtitle;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back?'**
  String get goBack;

  /// No description provided for @goBackContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? Your progress will be kept.'**
  String get goBackContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @selectBloodType.
  ///
  /// In en, this message translates to:
  /// **'Select blood type'**
  String get selectBloodType;

  /// No description provided for @nurseRegistration.
  ///
  /// In en, this message translates to:
  /// **'Nurse Registration'**
  String get nurseRegistration;

  /// No description provided for @uploadNurseLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload License/Certification'**
  String get uploadNurseLicense;

  /// No description provided for @serviceAreasLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Areas'**
  String get serviceAreasLabel;

  /// No description provided for @pleaseSelectServiceType.
  ///
  /// In en, this message translates to:
  /// **'Please select a service type'**
  String get pleaseSelectServiceType;

  /// No description provided for @pleaseSelectArea.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one area'**
  String get pleaseSelectArea;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get aiAssistant;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @nextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next Appointment'**
  String get nextAppointment;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @medicationReminder.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminder'**
  String get medicationReminder;

  /// No description provided for @markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as Taken'**
  String get markAsTaken;

  /// No description provided for @remindLater.
  ///
  /// In en, this message translates to:
  /// **'Remind Later'**
  String get remindLater;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @viewAndManage.
  ///
  /// In en, this message translates to:
  /// **'View & manage'**
  String get viewAndManage;

  /// No description provided for @bookDoctor.
  ///
  /// In en, this message translates to:
  /// **'Book Doctor'**
  String get bookDoctor;

  /// No description provided for @scheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Schedule appointment'**
  String get scheduleAppointment;

  /// No description provided for @requestNurse.
  ///
  /// In en, this message translates to:
  /// **'Request Nurse'**
  String get requestNurse;

  /// No description provided for @homeCareService.
  ///
  /// In en, this message translates to:
  /// **'Home care service'**
  String get homeCareService;

  /// No description provided for @scanMeal.
  ///
  /// In en, this message translates to:
  /// **'Scan Meal'**
  String get scanMeal;

  /// No description provided for @checkNutrition.
  ///
  /// In en, this message translates to:
  /// **'Check nutrition'**
  String get checkNutrition;

  /// No description provided for @addVitals.
  ///
  /// In en, this message translates to:
  /// **'Add Vitals'**
  String get addVitals;

  /// No description provided for @logHealthData.
  ///
  /// In en, this message translates to:
  /// **'Log health data'**
  String get logHealthData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
