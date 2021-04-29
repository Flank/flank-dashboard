// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/styled_circle_percentage.dart';

/// A class that represents the strategy of applying the [CirclePercentageStyle]
/// to the [StyledCirclePercentage] widget based on the percent value.
///
/// Gets the [CirclePercentageStyle] following the next rules:
/// * if the percent value is 0, applies the [MetricsThemeData.inactiveWidgetTheme]
/// * if the percent value is greater than [lowPercentBound] and less than
/// [mediumPercentBound], applies the [CirclePercentageAttentionLevel.negative]
/// * if the percent value is greater than or equal to [mediumPercentBound] and
/// less than [highPercentBound], applies the
/// [CirclePercentageAttentionLevel.neutral]
/// * if the percent value is greater or equal to [highPercentBound], applies
/// the [CirclePercentageAttentionLevel.positive].
class MetricsValueStyleStrategy
    implements ValueBasedAppearanceStrategy<CirclePercentageStyle, double> {
  /// Is the lower bound of the given value to return the
  /// [CirclePercentageAttentionLevel.positive].
  static const double highPercentBound = 0.8;

  /// Is the lower bound of the given value to return the
  /// [CirclePercentageAttentionLevel.neutral].
  static const double mediumPercentBound = 0.51;

  /// Is the lower bound of the given value to return the
  /// [CirclePercentageAttentionLevel.negative].
  static const double lowPercentBound = 0.0;

  /// Creates a new instance of the [MetricsValueStyleStrategy].
  const MetricsValueStyleStrategy();

  @override
  CirclePercentageStyle getWidgetAppearance(
    MetricsThemeData metricsTheme,
    double value,
  ) {
    final circlePercentageTheme = metricsTheme.circlePercentageTheme;
    final inactiveStyle = circlePercentageTheme.attentionLevel.inactive;
    final percent = value;

    if (percent == null) return inactiveStyle;

    if (percent >= highPercentBound) {
      return circlePercentageTheme.attentionLevel.positive;
    } else if (percent >= mediumPercentBound) {
      return circlePercentageTheme.attentionLevel.neutral;
    } else if (percent > lowPercentBound) {
      return circlePercentageTheme.attentionLevel.negative;
    } else {
      return inactiveStyle;
    }
  }
}
