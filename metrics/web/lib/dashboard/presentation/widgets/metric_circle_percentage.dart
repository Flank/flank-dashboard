import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metric_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [CirclePercentage] widget that displays the project metric
/// and applies the [MetricValueThemeStrategy].
class MetricCirclePercentage extends StatelessWidget {
  final PercentValueObject percent;

  const MetricCirclePercentage({
    Key key,
    this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedCirclePercentage(
      value: percent?.value,
      themeStrategy: const MetricValueThemeStrategy(),
    );
  }
}
