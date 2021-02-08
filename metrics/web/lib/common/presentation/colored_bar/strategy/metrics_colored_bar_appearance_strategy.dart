// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';

/// A class that represents the the strategy of applying the [MetricsThemeData]
/// to the [MetricsColoredBar] based on the given [Value].
abstract class MetricsColoredBarAppearanceStrategy<Value>
    implements ValueBasedAppearanceStrategy<MetricsColoredBarStyle, Value> {
  /// Creates a new instance of the [MetricsColoredBarAppearanceStrategy].
  const MetricsColoredBarAppearanceStrategy();
}
