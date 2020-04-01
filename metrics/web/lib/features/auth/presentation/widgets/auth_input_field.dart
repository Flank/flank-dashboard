import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';

/// The widget that represents a custom [TextFormField] for the [AuthForm].
class AuthInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool autocorrect;
  final bool autofocus;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputType keyboardType;

  /// Creates an [AuthInputField].
  const AuthInputField({
    this.label,
    this.controller,
    this.obscureText = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.validator,
    this.onFieldSubmitted,
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
        labelStyle: const TextStyle(fontSize: 14.0),
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
