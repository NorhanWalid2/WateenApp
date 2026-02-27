import 'package:flutter/material.dart';
import 'package:wateen_app/features/onboarding/data/models/model.dart';
//import '../../data/models/model.dart';

class OnboardingCustomWidget extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingCustomWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image box with red gradient
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF4B4B), Color(0xFFE00000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Image.asset(model.image, color: Colors.white),
          ),
        ),

        const SizedBox(height: 40),

        // Title
        Text(
          model.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 16),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            model.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
