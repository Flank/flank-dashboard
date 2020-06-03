import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graphs/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metric_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';

/// A [CirclePercentage] widget that displays the coverage metric
/// and applies the [MetricValueThemeStrategy].
class CoverageCirclePercentage extends StatelessWidget {
  final CoverageViewModel coverage;

  const CoverageCirclePercentage({
    Key key,
    @required this.coverage,
  })  : assert(coverage != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedCirclePercentage(
      percent: coverage,
      themeStrategy: const MetricValueThemeStrategy(),
    );
  }
}
