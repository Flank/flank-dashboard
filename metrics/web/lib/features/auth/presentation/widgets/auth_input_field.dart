import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';

/// The widget that represents a custom [TextFormField] for the [AuthForm].
class AuthInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool autofocus;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputType keyboardType;
  final FocusNode focusNode;

  /// Creates an [AuthInputField].
  ///
  /// [label] is the text title of the input.
  /// [controller] controls the text being edited.
  /// [obscureText] whether to hide the text being edited (e.g., for passwords).
  /// Defaults to false.
  /// [autofocus] whether this text field should be focused initially.
  /// Defaults to false.
  /// [validator] an optional method that validates an input.
  /// [onFieldSubmitted] called when a user submits content
  /// (e.g., user presses the "enter" button on the keyboard).
  /// [keyboardType] the type of information for which to optimize the text input control.
  /// [focusNode] defines the keyboard focus for this widget.
  const AuthInputField({
    Key key,
    this.label,
    this.controller,
    this.obscureText = false,
    this.autofocus = false,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14.0),
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
    );
  }
}
