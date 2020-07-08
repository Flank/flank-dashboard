import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';

/// A class that holds the common text field styles for application themes.
class TextFieldConfig {
  static const TextStyle fieldTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  static const InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: ColorConfig.darkInputColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: ColorConfig.darkInputSecondaryTextColor,
      fontSize: 16.0,
    ),
  );
}
