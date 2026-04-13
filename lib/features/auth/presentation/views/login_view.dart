import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/function/toast_message.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wateen_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/auth_switch_text.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginSuccess) {
                switch (state.role.toLowerCase()) {
                  case 'patient':
                    CustomReplacementNavigation(context, '/patient');
                    break;
                  case 'doctor':
                    CustomReplacementNavigation(context, '/doctorHome');
                    break;
                  case 'nurse':
                    CustomReplacementNavigation(context, '/nurseHome');
                    break;
                }
              } else if (state is AuthFailure) {
                final msg =
                    state.message == 'errorGeneral'
                        ? l10n.errorGeneral
                        : state.message;
                showToastMessage(context, msg, ToastType.error);
              }
            },
            builder: (context, state) {
              final cubit = context.read<AuthCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // ── AppBar ───────────────────
                      AppBarWidget(),
                      const SizedBox(height: 32),

                      // ── Welcome Text ─────────────
                      Text(l10n.welcomeBack, style: textTheme.headlineLarge),
                      const SizedBox(height: 6),
                      Text(
                        l10n.signInTo,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Form Card ────────────────
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Email ──────────────
                            CustomTextFormFieldWidget(
                              title: l10n.emailAddress,
                              hintText: l10n.enteryouremail,
                              controller: _emailController,
                              myValidator: Validator.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 20),

                            // ── Password ───────────
                            CustomTextFormFieldWidget(
                              title: l10n.password,
                              hintText: l10n.enteryourpassword,
                              controller: _passwordController,
                              myValidator: Validator.validatePassword,
                              isPassword: true,
                              obscureText: true,
                            ),

                            const SizedBox(height: 12),

                            // ── Remember me + Forgot ─
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: cubit.rememberMe,
                                      onChanged:
                                          (v) => cubit.toggleRememberMe(v!),
                                    ),
                                    Text(
                                      l10n.rememberMe,
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    return CustomNavigation(
                                      context,
                                      '/forgetPassword',
                                    );
                                  },
                                  child: Text(
                                    l10n.forgotPassword,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ── Sign In Button ──────
                            CustomButton(
                              title: l10n.signIn,
                              color: colorScheme.secondary,
                              colorText: colorScheme.primary,

                              onTap:
                                  state is AuthLoading
                                      ? null
                                      : () {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.login(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                        }
                                      },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Don't have an account ────
                      AuthSwitchText(
                        colorScheme: colorScheme,
                        firstText: l10n.dontHaveAnAccount,
                        secondText: l10n.signUp,
                        onTap: () => CustomNavigation(context, '/role'),
                      ),

                      const SizedBox(height: 24),

                      // ── Terms ────────────────────
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: l10n.byContinuing,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            children: [
                              TextSpan(
                                text: l10n.termsOfService,
                                style: TextStyle(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: l10n.privacyPolicy,
                                style: TextStyle(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
