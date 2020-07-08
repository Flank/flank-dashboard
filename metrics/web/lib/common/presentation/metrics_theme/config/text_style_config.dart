import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';

/// A class that holds the common text styles for application themes.
class TextStyleConfig {
  static const TextStyle captionTextStyle = TextStyle(
    color: ColorConfig.darkSecondaryTextColor,
    height: 1.23,
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );

  static const TextStyle darkBodyTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );
}
