import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/widgets/app_bar_widget.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/core/widgets/custom_text_form_field.dart';
import 'package:wateen_app/core/widgets/validator.dart';
import 'package:wateen_app/features/auth/presentation/cubit/login_cubi.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/auth_switch_text.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                CustomReplacementNavigation(context, '/home');
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── AppBar ───────────────────
                        AppBarWidget(),
                        const SizedBox(height: 32),

                        // ── Welcome Text ─────────────
                        Text(
                          AppStrings.welcomeBack,
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.signInTo,
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
                                title: AppStrings.emailAddress,
                                hintText: AppStrings.enteryouremail,
                                controller: _emailController,
                                myValidator: Validator.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 20),

                              // ── Password ───────────
                              CustomTextFormFieldWidget(
                                title: AppStrings.password,
                                hintText: AppStrings.enteryourpassword,
                                controller: _passwordController,
                                myValidator: Validator.validatePassword,
                                isPassword: true,
                                obscureText: true,
                              ),

                              const SizedBox(height: 12),

                              // ── Remember me + Forgot ─
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: cubit.rememberMe,
                                        onChanged:
                                            (v) => cubit.toggleRememberMe(v!),
                                      ),
                                      Text(
                                        AppStrings.rememberMe,
                                        style: textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: forgot password
                                    },
                                    child: Text(
                                      AppStrings.forgotPassword,
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
                                title: AppStrings.signIn,
                                color: colorScheme.secondary,
                                colorText: colorScheme.primary,

                                onTap:
                                    state is LoginLoading
                                        ? null
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            return CustomNavigation(
                                              context,
                                              '/profile',
                                            );
                                          }
                                        },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // ── Don't have an account ────
                        AuthSwitchText(
                          colorScheme: colorScheme,
                          firstText: AppStrings.dontHaveAnAccount,
                          secondText: AppStrings.signUp,
                          onTap: () => CustomNavigation(context, '/role'),
                        ),
                      ],
                    ),
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
