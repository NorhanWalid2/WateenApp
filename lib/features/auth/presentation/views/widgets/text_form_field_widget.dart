import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.icon,
    required this.hintText,
  });
  final Widget icon;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.surface,
      ),
      child: ListTile(
        leading: icon,
        title: TextFormField(
          style: TextStyle(color: colorScheme.onSurfaceVariant),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: colorScheme.outlineVariant),
            fillColor: colorScheme.surface,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.surface),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.secondary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
