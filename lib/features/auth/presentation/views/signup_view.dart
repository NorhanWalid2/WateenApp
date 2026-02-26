import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/enums/user_role.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_signup_form_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/nurse_signup_form_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/patient_signup_form_widget.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRole role = GoRouterState.of(context).extra as UserRole;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: AppBarWidget(),
            ),

            // ── Scrollable Content ───────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Title ──────────────────────
                    Text(
                      _getTitle(role),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(role),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Form ───────────────────────
                    switch (role) {
                      UserRole.doctor => DoctorSignUpFormWidget(),
                      UserRole.nurse => NurseSignupFormWidget(),
                      UserRole.patient => PatientSignupFormWidget(),
                    },

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getTitle(UserRole role) {
  switch (role) {
    case UserRole.doctor:
      return 'Doctor Registration';
    case UserRole.nurse:
      return 'Nurse Registration';
    case UserRole.patient:
      return 'Patient Registration';
  }
}

String _getSubtitle(UserRole role) {
  switch (role) {
    case UserRole.doctor:
      return 'Create your account to manage patient care';
    case UserRole.nurse:
      return 'Create your account to provide care services';
    case UserRole.patient:
      return 'Create your account to access healthcare services';
  }
}
