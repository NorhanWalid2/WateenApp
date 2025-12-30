import 'package:flutter/material.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/app_bar_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/signup_form_widget.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: appBarWidget(title: 'Doctor Registration'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomScrollView(
                  slivers: [SliverToBoxAdapter(child: SignUpFormWidget())],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
