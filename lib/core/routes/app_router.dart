import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/auth/presentation/views/login_view.dart';
import 'package:wateen_app/features/auth/presentation/views/role_view.dart';
import 'package:wateen_app/features/auth/presentation/views/signup_view.dart';
import 'package:wateen_app/features/onboarding/presentation/screens/onboarding.dart';
import 'package:wateen_app/features/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/settings/presentation/views/settings_view.dart';

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
  ],
);
