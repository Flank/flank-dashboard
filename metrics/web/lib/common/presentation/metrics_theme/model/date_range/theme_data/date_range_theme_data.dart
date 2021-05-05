// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/dashboard/presentation/widgets/date_range.dart';

/// A class that stores the theme data for the [DateRange] widget.
class DateRangeThemeData {
  /// A [MetricsTextStyle] of the date range.
  final MetricsTextStyle textStyle;

  /// Creates a new instance of the [DateRangeThemeData].
  ///
  /// If the [MetricsTextStyle] is `null`, an instance of the
  /// [MetricsTextStyle] is used.
  const DateRangeThemeData({
    MetricsTextStyle textStyle,
  }) : textStyle = textStyle ?? const MetricsTextStyle();
}
