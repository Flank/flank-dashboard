import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';

/// A class that holds the common text field styles for application themes.
class TextFieldConfig {
  static const TextStyle lightFieldTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  static const TextStyle darkFieldTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  static const TextStyle hintStyle = TextStyle(
    color: ColorConfig.inputSecondaryTextColor,
    fontSize: 16.0,
  );

  static const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide.none,
  );
}
