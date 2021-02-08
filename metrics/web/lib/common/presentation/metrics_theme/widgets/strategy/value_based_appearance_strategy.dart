// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// A base class for an appearance strategy based on some value.
///
/// Represents the strategy of applying the [MetricsWidgetThemeData] to the metrics widgets.
abstract class ValueBasedAppearanceStrategy<ReturnType, ValueType> {
  /// Provides the appearance accordingly to the [value].
  ReturnType getWidgetAppearance(MetricsThemeData themeData, ValueType value);
}
