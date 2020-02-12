import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';

class StabilityCirclePercentage extends StatelessWidget {
  final double value;

  const StabilityCirclePercentage({Key key, @required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final circlePercentageAccentTheme =
        MetricsTheme.of(context).circlePercentageAccentTheme;

    return CirclePercentage(
      title: 'STABILITY',
      value: value,
      valueColor: circlePercentageAccentTheme.primaryColor,
      strokeColor: circlePercentageAccentTheme.accentColor,
      backgroundColor: circlePercentageAccentTheme.backgroundColor,
    );
  }
}
