import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// A base class for an appearance strategy based on some value.
///
/// Represents the strategy of applying the [MetricWidgetThemeData] to the metric widgets.
abstract class ValueBasedAppearanceStrategy<ReturnType, ValueType> {
  /// Provides the appearance accordingly to the [value].
  ReturnType getWidgetAppearance(MetricsThemeData themeData, ValueType value);
}
