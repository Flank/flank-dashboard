// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/colored_bar/strategy/metrics_colored_bar_appearance_strategy.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the strategy of applying the [MetricsThemeData]
/// to the [BuildResultBar] based on the [BuildStatus] value.
class BuildResultBarAppearanceStrategy
    implements MetricsColoredBarAppearanceStrategy<BuildStatus> {
  /// Creates a new instance of the [BuildResultBarAppearanceStrategy].
  const BuildResultBarAppearanceStrategy();

  @override
  MetricsColoredBarStyle getWidgetAppearance(
    MetricsThemeData themeData,
    BuildStatus status,
  ) {
    final coloredBarTheme = themeData.metricsColoredBarTheme;
    final attentionLevel = coloredBarTheme.attentionLevel;

    switch (status) {
      case BuildStatus.successful:
        return attentionLevel.positive;
      case BuildStatus.failed:
        return attentionLevel.negative;
      case BuildStatus.unknown:
        return attentionLevel.neutral;
    }

    return null;
  }
}
