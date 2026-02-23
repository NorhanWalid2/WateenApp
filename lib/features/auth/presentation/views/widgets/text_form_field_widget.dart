import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_colors.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({super.key, required this.icon, required this.hintText});
  final Widget icon;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 241, 234, 234),
      ),
      child: ListTile(
        leading: icon,
        title: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: AppColors.grayColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 241, 234, 234),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 241, 234, 234),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
