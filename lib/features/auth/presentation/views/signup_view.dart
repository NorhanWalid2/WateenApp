import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/enums/user_role.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/app_bar_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_signup_form_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/nurse_signup_form_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/patient_signup_form_widget.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRole role = GoRouterState.of(context).extra as UserRole;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: appBarWidget(title: _getTitle(role)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: switch (role) {
                        UserRole.doctor => DoctorSignUpFormWidget(),
                        UserRole.nurse => NurseSignupFormWidget(),
                        UserRole.patient => PatientSignupFormWidget(),
                      },
                    ),
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
