import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';
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
  bool _isLoading = false;
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

  Future<void> _sendCode() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.enteryouremail),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // TODO: real API
    setState(() {
      _isLoading = false;
      _isOtpStep = true;
    });
    _startTimer();
  }

  Future<void> _verifyCode() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // TODO: real API
    setState(() => _isLoading = false);
    // TODO: navigate to reset password screen
  }

  void _resendCode() {
    for (var c in _otpControllers) c.clear();
    _sendCode();
  }

  void _changeEmail() {
    _timer?.cancel();
    for (var c in _otpControllers) c.clear();
    setState(() => _isOtpStep = false);
  }

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Back Button ──
              GestureDetector(
                onTap:
                    () => _isOtpStep ? _changeEmail() : Navigator.pop(context),
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
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Header Card ──
              WateenHeaderCard(subtitle: 'Reset your\npassword'),

              const SizedBox(height: 32),

              // ── Title ──
              Text(
                _isOtpStep ? AppStrings.verifyCode : AppStrings.resetPassword,
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

              // ── Step 1 or Step 2 ──
              if (!_isOtpStep)
                ForgetPasswordFormWidget(
                  emailController: _emailController,
                  isLoading: _isLoading,
                  onSend: _sendCode,
                )
              else
                OtpFormWidget(
                  otpControllers: _otpControllers,
                  focusNodes: _focusNodes,
                  timerSeconds: _timerSeconds,
                  isLoading: _isLoading,
                  onVerify: _verifyCode,
                  onResend: _resendCode,
                  onChangeEmail: _changeEmail,
                ),

              const SizedBox(height: 32),

              // ── Contact Support ──
              const ContactSupportText(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
