import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(),child: Text(AppStrings.byContinuing),);
  }
}