import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_style.dart';

/// A class that holds the common text styles for application themes.
class TextStyleConfig {
  static const String defaultFontFamily = 'Roboto';

  static const TextStyle captionTextStyle = MetricsTextStyle(
    color: ColorConfig.secondaryTextColor,
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonLabelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle popupTitleStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: ColorConfig.secondaryPopupTextColor,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle popupSubtitleStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: ColorConfig.popupTextColor,
    fontWeight: FontWeight.w500,
  );
}
