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
  ///
  /// [label] is the text title of the input.
  /// [controller] controls the text being edited.
  /// [obscureText] whether to hide the text being edited (e.g., for passwords).
  /// [autocorrect] whether to enable autocorrection.
  /// [autofocus] whether this text field should focus itself if nothing else is already focused.
  /// [validator] an optional method that validates an input.
  /// Returns an error string to display if the input is invalid, or null otherwise.
  /// [onFieldSubmitted] called when a user submits content (e.g., user presses the "enter" button on the keyboard).
  /// [keyboardType] the type of information for which to optimize the text input control.
  const AuthInputField({
    Key key,
    this.label,
    this.controller,
    this.obscureText = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
  }) : super(key: key);

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
