import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';
import 'package:metrics/dashboard/presentation/view_models/percent_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';

/// A [CirclePercentage] widget that applies the given [ValueBasedAppearanceStrategy].
class ThemedCirclePercentage extends StatelessWidget {
  /// A theme strategy applied to the [CirclePercentage] widget.
  final ValueBasedAppearanceStrategy<CirclePercentageStyle, double> themeStrategy;

  /// A [PercentViewModel] to display.
  final PercentViewModel percent;

  /// Creates the [ThemedCirclePercentage]
  /// with the given [percent] and [themeStrategy].
  ///
  /// The both [percent] and [themeStrategy] must not be `null`.
  const ThemedCirclePercentage({
    Key key,
    @required this.percent,
    @required this.themeStrategy,
  })  : assert(themeStrategy != null),
        assert(percent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = _getWidgetTheme(context);

    return CirclePercentage(
      value: percent?.value,
      placeholder: const NoDataPlaceholder(),
      valueStrokeWidth: 3.0,
      valueColor: widgetTheme?.valueColor,
      strokeColor: widgetTheme?.strokeColor,
      backgroundColor: widgetTheme?.backgroundColor,
      valueStyle: widgetTheme?.valueStyle,
    );
  }

  /// Gets the [MetricWidgetThemeData] using the [themeStrategy].
  CirclePercentageStyle _getWidgetTheme(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);

    return themeStrategy.getWidgetAppearance(metricsTheme, percent.value);
  }
}
