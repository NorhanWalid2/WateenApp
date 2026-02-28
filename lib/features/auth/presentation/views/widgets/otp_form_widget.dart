import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class OtpFormWidget extends StatelessWidget {
  final List<TextEditingController> otpControllers;
  final List<FocusNode> focusNodes;
  final int timerSeconds;
  final bool isLoading;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;

  const OtpFormWidget({
    super.key,
    required this.otpControllers,
    required this.focusNodes,
    required this.timerSeconds,
    required this.isLoading,
    required this.onVerify,
    required this.onResend,
    required this.onChangeEmail,
  });

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final bool canVerify = otpControllers.every((c) => c.text.isNotEmpty);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Enter Verification Code',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // 6 OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    height: 52,
                    child: TextFormField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE00000),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Timer or Resend
              timerSeconds > 0
                  ? RichText(
                    text: TextSpan(
                      text: 'Resend code in ',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      children: [
                        TextSpan(
                          text: _formatTimer(timerSeconds),
                          style: const TextStyle(
                            color: Color(0xFFE00000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                  : TextButton(
                    onPressed: onResend,
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                        color: Color(0xFFE00000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

              const SizedBox(height: 16),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: (canVerify && !isLoading) ? onVerify : null,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Verify Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canVerify
                            ? const Color(0xFFE00000)
                            : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Wrong email? Change Email
        RichText(
          text: TextSpan(
            text: 'Wrong email? ',
            style: const TextStyle(color: Colors.black, fontSize: 13),
            children: [
              TextSpan(
                text: 'Change Email',
                style: const TextStyle(
                  color: Color(0xFFE00000),
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = onChangeEmail,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
