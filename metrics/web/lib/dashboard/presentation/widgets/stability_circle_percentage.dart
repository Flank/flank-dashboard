import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';

/// A [CirclePercentage] widget that displays the stability metric
/// and applies the [MetricsValueThemeStrategy].
class StabilityCirclePercentage extends StatelessWidget {
  /// A [StabilityViewModel] to display.
  final StabilityViewModel stability;

  /// Creates the [StabilityCirclePercentage] with the given [stability].
  const StabilityCirclePercentage({
    Key key,
    @required this.stability,
  })  : assert(stability != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedCirclePercentage(
      percent: stability,
      themeStrategy: const MetricsValueThemeStrategy(),
    );
  }
}
