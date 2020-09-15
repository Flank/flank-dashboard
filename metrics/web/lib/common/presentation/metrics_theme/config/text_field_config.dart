import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';

/// A class that holds the common text field styles for application themes.
class TextFieldConfig {
  static const TextStyle errorStyle = TextStyle(
    color: ColorConfig.accentColor,
    fontSize: 16.0,
    height: 1.0,
  );

  static const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide.none,
  );

  static const errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: ColorConfig.accentColor),
  );
}
