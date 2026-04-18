import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/auth/presentation/views/forget_password_view.dart';
import 'package:wateen_app/features/auth/presentation/views/login_view.dart';
import 'package:wateen_app/features/auth/presentation/views/role_view.dart';
import 'package:wateen_app/features/auth/presentation/views/signup_view.dart';
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
import 'package:wateen_app/features/patient/settings/presentation/views/settings_view.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';
import 'package:wateen_app/features/patient/request_nurse/presentation/views/request_nurse_view.dart';
import 'package:wateen_app/features/patient/request_nurse/presentation/views/nurse_request_details_view.dart';
import 'package:wateen_app/features/splash/presentation/views/splash_view.dart';
 
import 'package:wateen_app/features/nurse/home/presentation/views/home_view.dart';
import 'package:wateen_app/features/nurse/layout/nurse_main_layout.dart';

String _getInitialRoute() {
  if (!AppPrefs.seenOnboarding) return '/';

  if (AppPrefs.token != null) {
    final jwt = JWT.decode(AppPrefs.token!);
    final role =
        jwt.payload['role'] ??
        jwt.payload[
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

    switch (role.toString().toLowerCase()) {
      case 'patient':
        return '/patient';
      case 'doctor':
        return '/doctorHome';
      case 'nurse':
        return '/nurseMain';
    }
  }

  return '/login';
}

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
    GoRoute(path: '/role', builder: (context, state) => const RoleView()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
    GoRoute(path: '/login', builder: (context, state) => LoginView()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
    // ── Auth ──────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: '/role',
      builder: (context, state) => const RoleView(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/forgetPassword',
      builder: (context, state) => const ForgetPasswordView(),
    ),

    // ── Patient ───────────────────────────────────
    GoRoute(
      path: '/patient',
      builder: (_, __) => const PatientMainLayout(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileView(),
    ),
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
    GoRoute(
      path: '/aiAssistant',
      builder: (_, __) => const AiAssistantView(),
    ),
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
    GoRoute(
      path: '/addVitals',
      builder: (_, __) => const HealthView(),
    ),

    // ── Nurse ─────────────────────────────────────
    GoRoute(
      path: '/nurseMain',
      builder: (_, __) => const NurseMainLayout(),
    ),
    GoRoute(
      path: '/nurseHome',
      builder: (_, __) => const NurseHomeView(),
    ),
    GoRoute(
  path: '/activeVisit',
  builder: (_, __) => const ActiveVisitView(),
),
GoRoute(
  path: '/nurseReports',
  builder: (_, __) => const ReportsView(),
),
GoRoute(
  path: '/nurseProfile',
  builder: (_, __) => const NurseProfileView(),
),
  ],
);