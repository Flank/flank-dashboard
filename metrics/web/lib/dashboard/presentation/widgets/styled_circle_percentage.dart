// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/percent_view_model.dart';

/// A [CirclePercentage] widget that applies the given [ValueBasedAppearanceStrategy].
class StyledCirclePercentage extends StatelessWidget {
  /// An appearance strategy applied to the [CirclePercentage] widget.
  final ValueBasedAppearanceStrategy<CirclePercentageStyle, double>
      appearanceStrategy;

  /// A [PercentViewModel] to display.
  final PercentViewModel percent;

  /// Creates the [StyledCirclePercentage]
  /// with the given [percent] and [appearanceStrategy].
  ///
  /// The both [percent] and [appearanceStrategy] must not be `null`.
  const StyledCirclePercentage({
    Key key,
    @required this.percent,
    @required this.appearanceStrategy,
  })  : assert(appearanceStrategy != null),
        assert(percent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = _getWidgetTheme(context);

    return CirclePercentage(
      value: percent?.value,
      placeholder: Center(
        child: Text(
          DashboardStrings.noDataPlaceholder,
          style: widgetTheme.valueStyle,
        ),
      ),
      valueStrokeWidth: 3.0,
      valueColor: widgetTheme?.valueColor,
      strokeColor: widgetTheme?.strokeColor,
      backgroundColor: widgetTheme?.backgroundColor,
      valueStyle: widgetTheme?.valueStyle,
    );
  }

  /// Gets the [MetricsWidgetThemeData] using the [appearanceStrategy].
  CirclePercentageStyle _getWidgetTheme(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);

    return appearanceStrategy.getWidgetAppearance(metricsTheme, percent.value);
  }
}
