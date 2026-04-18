import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_state.dart';
import 'widgets/wateen_header_card.dart';
import 'widgets/contact_support_text.dart';
import 'widgets/forget_password_form_widget.dart';
import 'widgets/otp_form_widget.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isOtpStep = false;
  int _timerSeconds = 56;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timerSeconds = 56;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _changeEmail() {
    _timer?.cancel();
    for (var c in _otpControllers) c.clear();
    setState(() => _isOtpStep = false);
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            // ✅ Email sent — go to OTP step
            setState(() => _isOtpStep = true);
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code sent to your email'),
                backgroundColor: Color(0xFF16A34A),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Back Button ──────────────────────────────────
                    GestureDetector(
                      onTap:
                          () =>
                              _isOtpStep
                                  ? _changeEmail()
                                  : Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                          Text(
                            'Back',
                            style: AppTextstyle.arimo16(context).copyWith(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    WateenHeaderCard(subtitle: 'Reset your\npassword'),
                    const SizedBox(height: 32),

                    Text(
                      _isOtpStep
                          ? AppStrings.verifyCode
                          : AppStrings.resetPassword,
                      style: AppTextstyle.arimo30(context),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isOtpStep
                          ? '${AppStrings.weSentA6Digit}\n${_emailController.text}'
                          : AppStrings.enterYourEmail,
                      style: AppTextstyle.archivo15w400Gray(context),
                    ),
                    const SizedBox(height: 24),

                    // ── Step 1: Send Email ───────────────────────────
                    if (!_isOtpStep)
                      ForgetPasswordFormWidget(
                        emailController: _emailController,
                        isLoading: isLoading,
                        onSend: () {
                          if (_emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppStrings.enteryouremail),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                            return;
                          }
                          // ✅ Call real API
                          context.read<AuthCubit>().forgotPassword(
                            email: _emailController.text.trim(),
                          );
                        },
                      )
                    // ── Step 2: OTP ──────────────────────────────────
                    else
                      OtpFormWidget(
                        otpControllers: _otpControllers,
                        focusNodes: _focusNodes,
                        timerSeconds: _timerSeconds,
                        isLoading: isLoading,
                        onVerify: () {
                          // ✅ Navigate to reset password with token
                          if (_otpCode.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Please enter the 6-digit code',
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                            return;
                          }
                          CustomNavigation(
                            context,
                            '/resetPassword',
                            extra: {
                              'email': _emailController.text.trim(),
                              'token': _otpCode,
                            },
                          );
                        },
                        onResend: () {
                          for (var c in _otpControllers) c.clear();
                          context.read<AuthCubit>().forgotPassword(
                            email: _emailController.text.trim(),
                          );
                        },
                        onChangeEmail: _changeEmail,
                      ),

                    const SizedBox(height: 32),
                    const ContactSupportText(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
