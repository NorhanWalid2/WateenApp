import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final String title;
  final TextInputType keyboardType;
  bool obscureText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? myValidator;
  final bool? readOrNot;
  void Function()? onTap;
  CustomTextFormFieldWidget({
    required this.title,
    required this.hintText,
    required this.controller,
    this.myValidator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.readOrNot,
    this.onTap,
    super.key,
  });

  @override
  State<CustomTextFormFieldWidget> createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
            overflow: TextOverflow.ellipsis,
          ),
          readOnly: widget.readOrNot ?? false,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: Colors.transparent,
            filled: true,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                    )
                    : null,

            contentPadding: const EdgeInsets.all(15),
            enabledBorder: outlineInputBorder(
              color: colorScheme.onTertiary,
              radius: 10,
              width: 1,
            ),
            focusedBorder: outlineInputBorder(
              color: colorScheme.outlineVariant,
              radius: 10,
              width: 1,
            ),
            errorBorder: outlineInputBorder(
              color: colorScheme.error,
              radius: 10,
              width: 1,
            ),
          ),
           keyboardType: widget.keyboardType,
  inputFormatters: widget.keyboardType == TextInputType.phone ||
          widget.keyboardType == TextInputType.number
      ? [FilteringTextInputFormatter.digitsOnly]
      : null,
          controller: widget.controller,
          validator: widget.myValidator,
          onTap: widget.onTap,
        ),
      ],
    );
  }

  OutlineInputBorder outlineInputBorder({
    required double radius,
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
