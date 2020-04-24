import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// [InheritedWidget] to provide the [MetricsThemeData].
///
/// Notifies the subscribed widgets to rebuild when the theme is changed.
class MetricsTheme extends InheritedWidget {
  static const MetricsThemeData _defaultMetricsThemeData = MetricsThemeData();

  final MetricsThemeData data;

  const MetricsTheme({
    @required Widget child,
    @required this.data,
  })  : assert(child != null),
        assert(data != null),
        super(child: child);

  /// Gets the current [MetricsTheme] from the [context].
  ///
  /// Subscribes the widget called from to theme changed rebuild notifications.
  /// If there are no [MetricsTheme] widget in widget tree,
  /// the [_defaultMetricsThemeData] will be returned.
  static MetricsThemeData of(BuildContext context) {
    final themeWidget =
        context.dependOnInheritedWidgetOfExactType<MetricsTheme>();

    return themeWidget?.data ?? _defaultMetricsThemeData;
  }

  @override
  bool updateShouldNotify(MetricsTheme oldWidget) {
    final oldData = oldWidget.data;

    return oldData.metricCirclePercentageThemeData !=
            data.metricCirclePercentageThemeData ||
        oldData.buildResultTheme != data.buildResultTheme ||
        oldData.metricWidgetTheme != data.metricWidgetTheme;
  }
}
