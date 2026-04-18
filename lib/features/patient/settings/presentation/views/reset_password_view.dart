import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/function/toast_message.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _passwordCtrl   = TextEditingController();
  final TextEditingController _confirmCtrl    = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm  = true;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    // Passed from ForgetPasswordView via GoRouter extra
    final extra   = GoRouterState.of(context).extra as Map<String, String>?;
    final email   = extra?['email'] ?? '';
    final token   = extra?['token'] ?? '';

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthResetPasswordSuccess) {
            showToastMessage(
                context, 'Password reset successfully!', ToastType.success);
            CustomReplacementNavigation(context, '/login');
          } else if (state is AuthFailure) {
            showToastMessage(context, state.message, ToastType.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // ── AppBar ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: AppBarWidget(),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('New Password',
                              style: textTheme.headlineMedium),
                          const SizedBox(height: 6),
                          Text(
                            'Create a new secure password for your account',
                            style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 32),

                          // ── New Password ──────────────────────────
                          _buildPasswordField(
                            context: context,
                            controller: _passwordCtrl,
                            label: 'New Password',
                            hint: 'Enter new password',
                            obscure: _obscurePassword,
                            onToggle: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          const SizedBox(height: 16),

                          // ── Confirm Password ──────────────────────
                          _buildPasswordField(
                            context: context,
                            controller: _confirmCtrl,
                            label: 'Confirm Password',
                            hint: 'Re-enter new password',
                            obscure: _obscureConfirm,
                            onToggle: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                          const SizedBox(height: 32),

                          // ── Reset Button ──────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_passwordCtrl.text.isEmpty) {
                                        showToastMessage(
                                            context,
                                            'Please enter a password',
                                            ToastType.error);
                                        return;
                                      }
                                      if (_passwordCtrl.text !=
                                          _confirmCtrl.text) {
                                        showToastMessage(
                                            context,
                                            'Passwords do not match',
                                            ToastType.error);
                                        return;
                                      }
                                      if (_passwordCtrl.text.length < 6) {
                                        showToastMessage(
                                            context,
                                            'Password must be at least 6 characters',
                                            ToastType.error);
                                        return;
                                      }
                                      context
                                          .read<AuthCubit>()
                                          .resetPassword(
                                            userId: email,
                                            token: token,
                                            newPassword: _passwordCtrl.text,
                                            confirmNewPassword:
                                                _confirmCtrl.text,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.secondary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5),
                                    )
                                  : Text(
                                      'Reset Password',
                                      style: textTheme.titleSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: textTheme.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: colorScheme.outline.withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.inverseSurface),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline_rounded,
                  color: colorScheme.onSurfaceVariant, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
              hintText: hint,
              hintStyle: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}