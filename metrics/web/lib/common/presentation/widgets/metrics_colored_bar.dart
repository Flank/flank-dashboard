import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/style/build_result_bar_style.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';

/// Rectangle bar of the [BarGraph] painted based on [barStyleStrategy] and [buildStatus].
class MetricsColoredBar <Style extends BuildResultBarStyle, Value> extends StatelessWidget {
  /// A border radius of this bar.
  static const _borderRadius = Radius.circular(1.0);

  /// A width of this bar.
  static const _barWidth = 10.0;

  final ValueBasedAppearanceStrategy<Style, Value> barStrategy;
  final Value status;
  final double height;
  final bool isHovered;

  const MetricsColoredBar({Key key, this.barStrategy, this.status, this.height, this.isHovered}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = barStrategy.getWidgetAppearance(
      MetricsTheme.of(context),
      status,
    );

    return Container(
      width: _barWidth,
      color: isHovered ? theme.backgroundColor : null,
      alignment: Alignment.bottomCenter,
      child: ColoredBar(
        width: _barWidth,
        height: height,
        borderRadius: const BorderRadius.only(
          topLeft: _borderRadius,
          topRight: _borderRadius,
        ),
        color: theme.color,
      ),
    );
  }
}

/// Colors.red, yellow,              green, blue
