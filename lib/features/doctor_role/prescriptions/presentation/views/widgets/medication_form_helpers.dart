import 'package:flutter/material.dart';

class MedicationFieldLabel extends StatelessWidget {
  final String label;
  const MedicationFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFE7000B)),
          ),
        ],
      ),
    );
  }
}

class MedicationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const MedicationInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.outlineVariant,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      ),
    );
  }
}

class MedicationDropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const MedicationDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}