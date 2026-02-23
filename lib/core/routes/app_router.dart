import 'package:go_router/go_router.dart';
import 'package:wateen_app/features/auth/presentation/views/role_view.dart';
import 'package:wateen_app/features/auth/presentation/views/signup_view.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return RoleView();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return SignupView();
      },
    ),
  ],
);
