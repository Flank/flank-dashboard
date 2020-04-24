import 'package:meta/meta.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';

/// A theme data for the [CirclePercentage] widget.
///
/// Provides the theme data for [CirclePercentage] widget
/// with low, medium, and high percent.
@immutable
class MetricCirclePercentageThemeData {
  final MetricWidgetThemeData lowPercentTheme;
  final MetricWidgetThemeData mediumPercentTheme;
  final MetricWidgetThemeData highPercentTheme;

  /// Creates the [MetricCirclePercentageThemeData].
  ///
  /// [highPercentTheme] is the theme of the [CirclePercentage] widget
  /// with high percent value.
  ///
  /// [mediumPercentTheme] is the theme of the [CirclePercentage] widget
  /// with medium percent value.
  ///
  /// [lowPercentTheme] is the theme of the [CirclePercentage] widget
  /// with low percent value.
  const MetricCirclePercentageThemeData({
    MetricWidgetThemeData lowPercentTheme,
    MetricWidgetThemeData mediumPercentTheme,
    MetricWidgetThemeData highPercentTheme,
  })  : lowPercentTheme = lowPercentTheme ?? const MetricWidgetThemeData(),
        mediumPercentTheme =
            mediumPercentTheme ?? const MetricWidgetThemeData(),
        highPercentTheme = highPercentTheme ?? const MetricWidgetThemeData();
}
