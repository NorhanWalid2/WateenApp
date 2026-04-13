import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wateen_app/core/enums/user_role.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/function/toast_message.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/doctor_signup_form_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/nurse_signup_form_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/patient_signup_form_widget.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final UserRole role = GoRouterState.of(context).extra as UserRole;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                // ── AppBar ─────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: AppBarWidget(),
                ),

                // ── Scrollable Content ──────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          _getTitle(role, l10n),
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSubtitle(role, l10n),
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        switch (role) {
                          UserRole.doctor => BlocProvider(
                            create: (_) => AuthCubit(),
                            child: BlocListener<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  showToastMessage(
                                    context,
                                    l10n.registerSuccess,
                                    ToastType.success,
                                  );
                                  CustomReplacementNavigation(
                                    context,
                                    '/login',
                                  );
                                } else if (state is AuthFailure) {
                                  showToastMessage(
                                    context,
                                    state.message,
                                    ToastType.error,
                                  );
                                }
                              },
                              child: DoctorSignUpFormWidget(),
                            ),
                          ),
                          UserRole.nurse => BlocProvider(
                            create: (_) => AuthCubit(),
                            child: BlocListener<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  showToastMessage(
                                    context,
                                    l10n.registerSuccess,
                                    ToastType.success,
                                  );
                                  CustomReplacementNavigation(
                                    context,
                                    '/login',
                                  );
                                } else if (state is AuthFailure) {
                                  showToastMessage(
                                    context,
                                    state.message,
                                    ToastType.error,
                                  );
                                }
                              },
                              child: NurseSignupFormWidget(),
                            ),
                          ),
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
        ),
      ),
    );
  }
}

String _getTitle(UserRole role, AppLocalizations l10n) {
  switch (role) {
    case UserRole.doctor:
      return l10n.doctorRegistration;
    case UserRole.nurse:
      return l10n
          .patientRegistration; // ← غيري لـ nurseRegistration لو أضفتيه في ARB
    case UserRole.patient:
      return l10n.patientRegistration;
  }
}

String _getSubtitle(UserRole role, AppLocalizations l10n) {
  switch (role) {
    case UserRole.doctor:
      return l10n.managepatientcare;
    case UserRole.nurse:
      return l10n.providecareservices;
    case UserRole.patient:
      return l10n.createyouraccount;
  }
}
