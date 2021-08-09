// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/metrics_colors.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';

/// A class that holds the common text styles for application themes.
class TextStyleConfig {
  /// A default font family used in the project.
  static const String defaultFontFamily = 'Roboto';

  /// A [TextStyle] of the caption text.
  static TextStyle captionTextStyle = MetricsTextStyle(
    color: MetricsColors.grey[300],
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    fontWeight: FontWeight.w500,
  );

  /// A [TextStyle] of the popup title.
  static TextStyle popupTitleStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: MetricsColors.grey[300],
    fontWeight: FontWeight.normal,
  );

  /// A [TextStyle] of the popup subtitle.
  static TextStyle popupSubtitleStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: MetricsColors.grey[800],
    fontWeight: FontWeight.w500,
  );

  /// A [TextStyle] of the tooltip popup.
  static TextStyle tooltipPopupStyle = MetricsTextStyle(
    fontSize: 13.0,
    lineHeightInPixels: 16.0,
    color: MetricsColors.grey[800],
    fontWeight: FontWeight.normal,
  );
}
