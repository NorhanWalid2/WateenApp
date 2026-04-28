import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/admin_roles/admin_settings/presentation/views/settings_view.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/views/dashboard_view.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/views/doctors_management_view.dart';
import 'package:wateen_app/features/admin_roles/homeService_management/presentation/views/home_service_management_view.dart';
import 'package:wateen_app/features/admin_roles/layout/admin_main_layout.dart';
import 'package:wateen_app/features/admin_roles/patients_management/presentation/views/patients_management_view.dart';
import 'package:wateen_app/features/auth/presentation/views/forget_password_view.dart';
import 'package:wateen_app/features/auth/presentation/views/login_view.dart';
import 'package:wateen_app/features/auth/presentation/views/role_view.dart';
import 'package:wateen_app/features/auth/presentation/views/signup_view.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/views/appointments_view.dart';
import 'package:wateen_app/features/doctor_role/chat_/presentation/views/chat_view.dart';
import 'package:wateen_app/features/doctor_role/checklist/presentation/views/checklist_view.dart';
import 'package:wateen_app/features/doctor_role/dashboard/presentation/views/dashboard_view.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/doctor_role/layout/doctor_main_layout.dart';
import 'package:wateen_app/features/doctor_role/messages_/presentation/views/messages_view.dart';
import 'package:wateen_app/features/doctor_role/patient_details/presentation/views/patient_details_view.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/views/patients_view.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/presentation/views/prescriptions_view.dart';
import 'package:wateen_app/features/nurse/active_visit/presentation/views/active_visit_view.dart';
import 'package:wateen_app/features/nurse/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/nurse/reports/presentation/views/reports_view.dart';
import 'package:wateen_app/features/onboarding/presentation/screens/onboarding.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/views/ai_assistant_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointment_details_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointments_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/reschedule_appointment_view.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/views/book_appointment_view.dart';
import 'package:wateen_app/features/patient/health/presentation/views/health_view.dart';
import 'package:wateen_app/features/patient/home/presentation/views/home_view.dart';
import 'package:wateen_app/features/patient/layout/patient_main_layout.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/patient/settings/presentation/views/change_password_view.dart';
import 'package:wateen_app/features/patient/settings/presentation/views/settings_view.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';
import 'package:wateen_app/features/patient/request_nurse/presentation/views/request_nurse_view.dart';
import 'package:wateen_app/features/patient/request_nurse/presentation/views/nurse_request_details_view.dart';
import 'package:wateen_app/features/splash/presentation/views/splash_view.dart';

import 'package:wateen_app/features/nurse/home/presentation/views/nurse_home_view.dart';
import 'package:wateen_app/features/nurse/layout/nurse_main_layout.dart';

String _getInitialRoute() {
  if (!AppPrefs.seenOnboarding) return '/';

  if (AppPrefs.token != null) {
    final jwt = JWT.decode(AppPrefs.token!);
    final role =
        jwt.payload['role'] ??
        jwt.payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

    switch (role.toString().toLowerCase()) {
      case 'patient':
        return '/patient';
      case 'doctor':
        return '/doctorHome';
      case 'nurse':
        return '/nurseMain';
      case 'admin':
        return '/adminMain';
      case 'doctor':
        return '/doctorMain';
    }
  }

  return '/login';
}

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashView()),
    GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
    GoRoute(path: '/role', builder: (context, state) => const RoleView()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
    GoRoute(path: '/login', builder: (context, state) => LoginView()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
    // ── Auth ──────────────────────────────────────
    GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
    GoRoute(path: '/role', builder: (context, state) => const RoleView()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
    GoRoute(path: '/login', builder: (context, state) => LoginView()),
    GoRoute(
      path: '/forgetPassword',
      builder: (context, state) => const ForgetPasswordView(),
    ),
    GoRoute(
      path: '/changePassword',
      builder: (_, __) => const ChangePasswordView(),
    ),

    // ── Patient ───────────────────────────────────
    GoRoute(path: '/patient', builder: (_, __) => const PatientMainLayout()),
    GoRoute(path: '/home', builder: (context, state) => const HomeView()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/appointments',
      builder: (_, __) => const AppointmentsView(),
    ),
    GoRoute(
      path: '/appointmentsDetails',
      builder: (_, __) => const AppointmentDetailsView(),
    ),
    GoRoute(
      path: '/rescheduleAppointments',
      builder: (_, __) => const RescheduleAppointmentView(),
    ),
    GoRoute(path: '/aiAssistant', builder: (_, __) => const AiAssistantView()),
    GoRoute(
      path: '/bookAppointment',
      builder: (_, __) => const BookAppointmentView(),
    ),
    GoRoute(
      path: '/requestNurse',
      builder: (_, __) => const RequestNurseView(),
    ),
    GoRoute(
      path: '/nurseRequestDetails',
      builder: (context, state) {
        final nurse = state.extra as NurseModel;
        return NurseRequestDetailsView(nurse: nurse);
      },
    ),
    GoRoute(path: '/addVitals', builder: (_, __) => const HealthView()),

    // ── Nurse ─────────────────────────────────────
    // In app_router.dart — make sure nurse route uses NurseMainLayout:
    GoRoute(path: '/nurseMain', builder: (_, __) => const NurseMainLayout()),
    
 
   
    // ── Admin ─────────────────────────────────────
    GoRoute(path: '/adminMain', builder: (_, __) => const AdminMainLayout()),
    GoRoute(
      path: '/adminDashboard',
      builder: (_, __) => const AdminDashboardView(),
    ),
    GoRoute(
      path: '/doctorsManagement',
      builder: (_, __) => const DoctorsManagementView(),
    ),
    GoRoute(
      path: '/patientsManagement',
      builder: (_, __) => const PatientsManagementView(),
    ),
    GoRoute(
      path: '/homeServiceManagement',
      builder: (_, __) => const HomeServiceManagementView(),
    ),
    GoRoute(
      path: '/adminSettings',
      builder: (_, __) => const AdminSettingsView(),
    ),
    // ── Doctor ─────────────────────────────────────
    GoRoute(path: '/doctorMain', builder: (_, __) => const DoctorMainLayout()),
    GoRoute(
      path: '/doctorDashboard',
      builder: (_, __) => const DoctorDashboardView(),
    ),
    GoRoute(
      path: '/doctorPatients',
      builder: (_, __) => const DoctorPatientsView(),
    ),
    GoRoute(
      path: '/patientDetails',
      builder: (context, state) {
        final patient = state.extra as PatientModel;
        return PatientDetailsView(patient: patient);
      },
    ),
    GoRoute(
      path: '/prescriptions',
      builder: (context, state) {
        final patient = state.extra as PatientModel;
        return PrescriptionsView(patient: patient);
      },
    ),
    GoRoute(
      path: '/checklist',
      builder: (context, state) {
        final patient = state.extra as PatientModel;
        return ChecklistView(patient: patient);
      },
    ),
    GoRoute(
      path: '/doctorAppointments',
      builder: (_, __) => const DoctorAppointmentsView(),
    ),
    GoRoute(
      path: '/doctorMessages',
      builder: (_, __) => const DoctorMessagesView(),
    ),
    GoRoute(
      path: '/doctorChat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return DoctorChatView(
          patientName: extra['patientName'] as String,
          patientId: extra['patientId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/doctorProfile',
      builder: (_, __) => const DoctorProfileView(),
    ),
  ],
);
