// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';

/// A class that holds the common text styles for application themes.
class TextStyleConfig {
  /// A default font family used in the project.
  static const String defaultFontFamily = 'Roboto';

  /// A [TextStyle] of the caption text.
  static const TextStyle captionTextStyle = MetricsTextStyle(
    color: ColorConfig.secondaryTextColor,
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    fontWeight: FontWeight.w500,
  );

  /// A [TextStyle] of the button label.
  static const TextStyle buttonLabelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  /// A [TextStyle] of the popup title.
  static const TextStyle popupTitleStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: ColorConfig.shimmerColor,
    fontWeight: FontWeight.normal,
  );

  /// A [TextStyle] of the popup subtitle.
  static const TextStyle popupSubtitleStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: ColorConfig.popupTextColor,
    fontWeight: FontWeight.w500,
  );

  /// A [TextStyle] of the tooltip popup.
  static const TextStyle tooltipPopupStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: ColorConfig.popupTextColor,
    fontWeight: FontWeight.normal,
  );
}
