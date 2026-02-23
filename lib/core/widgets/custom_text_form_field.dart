import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);


class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final String title;
  final TextInputType keyboardType;
  bool obscureText;
  final bool isPassword;
  final TextEditingController controller;
  final Validator myValidator;

  TextFormFieldWidget({
    required this.title,
    required this.hintText,
    required this.controller,
    required this.myValidator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    super.key,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 2,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff716C7E),
          ),
        ),

        TextFormField(
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),

          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: Colors.grey.shade100,
            filled: true,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      widget.obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xff454A4F),
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
              color: Color(0xff716C7E),
              radius: 10,
              width: 1,
            ),
            focusedBorder: outlineInputBorder(
              color: Color(0xff5F33E1),
              radius: 10,
              width: 1,
            ),
            errorBorder: outlineInputBorder(
              color: Color(0xffFF4949),
              radius: 10,
              width: 1,
            ),
          ),
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          validator: widget.myValidator,
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