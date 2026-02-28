import 'dart:async';
import 'package:flutter/material.dart';
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
  // ── Controllers ──
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // ── Local State ──
  bool _isOtpStep = false;
  bool _isLoading = false;
  int _timerSeconds = 56;
  Timer? _timer;

  // ── Timer ──
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

  // ── Send Code ──
  Future<void> _sendCode() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // TODO: real API call
    setState(() {
      _isLoading = false;
      _isOtpStep = true;
    });
    _startTimer();
  }

  // ── Verify OTP ──
  Future<void> _verifyCode() async {
    final otp = _otpControllers.map((c) => c.text).join();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // TODO: real API call
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(
      context,
      '/reset-password',
    ); // TODO: your route
  }

  // ── Resend ──
  void _resendCode() {
    for (var c in _otpControllers) c.clear();
    _sendCode();
  }

  // ── Change Email ──
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back button
              GestureDetector(
                onTap: () {
                  if (_isOtpStep) {
                    _changeEmail();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 16),
                    Text('Back'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const WateenHeaderCard(subtitle: 'Reset your\npassword'),

              const SizedBox(height: 32),

              // Title
              Text(
                _isOtpStep ? 'Verify Code' : 'Reset Password',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isOtpStep
                    ? 'We sent a 6-digit code to\n${_emailController.text}'
                    : "Enter your email address and we'll send you a\nverification code to reset your password",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Step 1 or Step 2
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

              const ContactSupportText(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
