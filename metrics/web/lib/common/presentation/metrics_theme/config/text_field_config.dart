import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_style.dart';

/// A class that holds the common text field styles for application themes.
class TextFieldConfig {
  static const TextStyle hintStyle = MetricsTextStyle(
    color: ColorConfig.inputSecondaryTextColor,
    fontSize: 16.0,
    lineHeightInPixels: 20,
  );

  static const TextStyle lightHintStyle = MetricsTextStyle(
    color: LightMetricsThemeData.inputHintTextColor,
    fontSize: 16.0,
    lineHeightInPixels: 20,
  );

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
