import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// A base class for a theme strategy based on some value.
///
/// Represents the strategy of applying the [MetricWidgetThemeData] to the metric widgets.
abstract class ValueBasedThemeStrategy<ReturnType, ValueType> {
  /// Provides the theme accordingly to the [value].
  ReturnType getWidgetTheme(MetricsThemeData themeData, ValueType value);
}
