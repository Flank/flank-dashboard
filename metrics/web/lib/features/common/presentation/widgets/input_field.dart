import 'package:flutter/material.dart';

@immutable
class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool autocorrect;
  final bool autofocus;
  final double fontSize;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  const InputField({
    this.label,
    this.controller,
    this.obscureText = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.fontSize = 14.0,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: fontSize),
      ),
      validator: validator,
    );
  }
}
