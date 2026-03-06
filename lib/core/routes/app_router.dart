import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/auth/presentation/views/forget_password_view.dart';
import 'package:wateen_app/features/auth/presentation/views/login_view.dart';
import 'package:wateen_app/features/auth/presentation/views/role_view.dart';
import 'package:wateen_app/features/auth/presentation/views/signup_view.dart';
import 'package:wateen_app/features/onboarding/presentation/screens/onboarding.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointment_details_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/appointments_view.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/reschedule_appointment_view.dart';
import 'package:wateen_app/features/patient/home/presentation/views/home_view.dart';
import 'package:wateen_app/features/patient/layout/patient_main_layout.dart';
import 'package:wateen_app/features/patient/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/patient/settings/presentation/views/settings_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
    GoRoute(path: '/role', builder: (context, state) => const RoleView()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
    GoRoute(path: '/login', builder: (context, state) => LoginView()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/forgetPassword',
      builder: (context, state) => const ForgetPasswordView(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeView()),
    GoRoute(path: '/patient', builder: (_, __) => const PatientMainLayout()),
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
    
  ],
);
