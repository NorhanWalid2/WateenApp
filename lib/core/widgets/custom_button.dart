import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.color,
    required this.colorText,
    this.onTap, required this.title,
  });
  final Color? color;
  final Color? colorText;
  final void Function()? onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,

          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
           title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorText,
            ),
          ),
        ),
      ),
    );
  }
}
