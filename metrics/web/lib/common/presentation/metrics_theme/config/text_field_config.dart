import 'package:flutter/material.dart';

/// A class that holds the common text field styles for application themes.
class TextFieldConfig {
  static const Color inputHintTextColor = Color(0xFF545459);

  static const TextStyle hintStyle = TextStyle(
    color: inputHintTextColor,
    fontSize: 16.0,
  );

  static const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide.none,
  );
}
