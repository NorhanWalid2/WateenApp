abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
class AuthPasswordVisibilityChanged extends AuthState {
  final bool isVisible;
  AuthPasswordVisibilityChanged(this.isVisible);
}
class AuthLoginSuccess extends AuthState {
  final String role;
  AuthLoginSuccess({required this.role});
}
// ── New states ────────────────────────────────────────────────────────────────
class AuthForgotPasswordSuccess extends AuthState {}
class AuthResetPasswordSuccess extends AuthState {}