import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';

/// A class that holds the common text styles for application themes.
class TextStyleConfig {
  static const String defaultFontFamily = 'Roboto';

  static const TextStyle captionTextStyle = TextStyle(
    color: ColorConfig.secondaryTextColor,
    height: 1.23,
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonLabelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );
}
